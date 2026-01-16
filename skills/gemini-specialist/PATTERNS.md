# Gemini Specialist - Safety Patterns & Decision Trees

Detailed strategies for safe Gemini CLI orchestration.

---

## Safety Evaluation Framework

### Pre-Flight Checklist (Before Invoking Gemini)

```yaml
1. File Criticality Assessment:
   LOW: Documentation, logs, temp files, new files
   MEDIUM: Source code, tests, build configs
   HIGH: .env, database schemas, auth logic, production configs

2. Git Status Check:
   CLEAN: Working directory clean → Safe to proceed
   UNCOMMITTED: Changes present → Commit first or use temp
   UNTRACKED: New files → Safe for new output

3. Operation Type:
   ANALYSIS: Read-only → Always safe
   GENERATION: New file → Safe if not overwriting
   MODIFICATION: Existing file → Requires validation strategy

4. Reversibility:
   INSTANT: Git available, file tracked → Easy rollback
   MANUAL: File not tracked → Backup manually
   CRITICAL: Production data, configs → Extra caution

5. Output Predictability:
   HIGH: Bounded scope, clear instructions → Direct OK
   MEDIUM: Complex task, may hallucinate → Temp-first
   LOW: Open-ended, creative → Requires review
```

---

## Decision Tree

```
START
  ↓
Is operation ANALYSIS only?
  YES → [DIRECT] Execute, review output
  NO → Continue
  ↓
Is file tracked in git?
  NO → Is file critical?
      YES → [BACKUP] Copy file, then temp-first
      NO → [TEMP-FIRST] Review before applying
  YES → Continue
  ↓
Is working directory clean?
  NO → [COMMIT-FIRST] git add . && git commit
  YES → Continue
  ↓
Is file criticality HIGH?
  YES → [GIT-SAFETY-NET] Commit + temp-first + diff review
  NO → Continue
  ↓
Is output predictable?
  YES → [DIRECT] Execute with clear prompt
  NO → [TEMP-FIRST] Review before applying
```

---

## Pattern Implementations

### Pattern 1: Direct Execution (Lowest Overhead)

**When:**
- Analysis operations
- New files (no overwrite risk)
- Low criticality + predictable output
- Git available (easy rollback)

**Implementation:**
```bash
# Pre-flight
[ -f .git/config ] || echo "WARNING: No git - proceed carefully"

# Execute
gemini -p "specific bounded prompt" < input --yolo -o text > output

# Validate
if [ -f output ]; then
  wc -l output  # Check not empty
  head -20 output  # Preview
else
  echo "ERROR: Gemini produced no output"
fi
```

**Risk:** Low (reversible via git)

---

### Pattern 2: Temp-First Review (Balanced)

**When:**
- Modifying existing files
- Medium criticality
- Want to review before applying

**Implementation:**
```bash
# Pre-flight
original_file="auth.py"
temp_output="/tmp/gemini-$(basename $original_file)-$(date +%s).tmp"

# Execute to temp
gemini -p "refactor with constraints..." < "$original_file" --yolo -o text > "$temp_output"

# Validate
if [ ! -s "$temp_output" ]; then
  echo "ERROR: Gemini output is empty"
  exit 1
fi

# Review (Claude shows user)
echo "=== CHANGES PREVIEW ==="
diff "$original_file" "$temp_output" || true

# Wait for approval
read -p "Apply changes? (y/n) " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
  cp "$temp_output" "$original_file"
  echo "✅ Applied"
else
  echo "❌ Cancelled - temp file: $temp_output"
fi
```

**Risk:** Low (user reviews before apply)

---

### Pattern 3: Git Safety Net (High Safety)

**When:**
- High criticality files
- Risky operations
- Production configs
- Want instant rollback

**Implementation:**
```bash
# Pre-flight: Ensure git is clean or commit
if ! git diff-index --quiet HEAD --; then
  echo "Uncommitted changes detected - committing..."
  git add .
  git commit -m "backup: before Gemini operation on $file"
fi

# Create safety commit
file="important.py"
git add "$file"
git commit -m "safety: before Gemini refactor of $file"

# Execute (can be direct since rollback is instant)
gemini -p "prompt" < "$file" --yolo -o text > "$file.new"

# Validate
if python -m py_compile "$file.new" 2>/dev/null; then
  mv "$file.new" "$file"
  echo "✅ Refactored successfully"
else
  echo "❌ Syntax error detected - rolling back"
  git restore "$file"
  rm "$file.new"
fi
```

**Risk:** Very Low (instant git rollback)

---

### Pattern 4: Validation Pipeline (Maximum Safety)

**When:**
- Critical files + complex modifications
- Want multi-layer validation
- Production code

**Implementation:**
```bash
file="critical.py"

# Layer 1: Git safety
git add . && git commit -m "backup: before Gemini on $file"

# Layer 2: Temp output
temp="/tmp/gemini-output.py"
gemini -p "refactor..." < "$file" --yolo -o text > "$temp"

# Layer 3: Syntax validation
if ! python -m py_compile "$temp"; then
  echo "❌ Syntax error - aborting"
  exit 1
fi

# Layer 4: Diff review
diff "$file" "$temp" > /tmp/changes.diff
echo "=== Review changes ==="
cat /tmp/changes.diff

# Layer 5: Test if available
if [ -f "test_${file}" ]; then
  cp "$temp" "$file"
  pytest "test_${file}"
  if [ $? -ne 0 ]; then
    echo "❌ Tests failed - rolling back"
    git restore "$file"
    exit 1
  fi
fi

# Layer 6: Final confirmation
read -p "All checks passed. Apply? (y/n) " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
  cp "$temp" "$file"
  git add "$file"
  git commit -m "refactor: Gemini-assisted changes (validated)"
else
  git restore "$file"
fi
```

**Risk:** Minimal (6 validation layers)

---

## Prompt Engineering for Safety

### Safe Prompt Structure

```bash
gemini -p "
[ACTION]: Clear verb (Analyze, Generate, Refactor)
[SCOPE]: Specific boundaries (only function X, lines 10-50)
[CONSTRAINTS]: What to preserve (all signatures, error handling)
[OUTPUT]: Format specification (complete file, diff only, markdown)
[VALIDATION]: Self-check request (include test cases)
" < input --yolo -o text
```

### Example: Safe Refactoring Prompt

```bash
# ✅ GOOD - Bounded and specific
gemini -p "Refactor the authenticate() function in this file to use async/await.
PRESERVE: All function signatures, error handling, logging.
SCOPE: Only modify authenticate() and its helpers.
OUTPUT: Complete file with changes.
VALIDATION: Ensure no functionality is removed." < auth.py --yolo -o text

# ❌ BAD - Vague and unbounded
gemini -p "Make this code better" < auth.py --yolo -o text
```

---

## Red Flags & Intervention Points

### When Claude Should Stop and Alert User

1. **Output Integrity Issues:**
   - File is truncated (incomplete)
   - Syntax errors detected
   - Critical sections removed
   - Unexpected file size change (>50% smaller)

2. **Scope Violations:**
   - Gemini modified unrelated code
   - Changed more than prompted
   - Removed functionality not mentioned

3. **Hallucination Indicators:**
   - Invented functions/imports not in original
   - Changed logic fundamentally
   - Added features not requested

4. **Data Loss Risks:**
   - Configuration keys removed
   - Environment variables deleted
   - Critical constants changed

### Intervention Script

```bash
# Claude's validation function
validate_gemini_output() {
  local original="$1"
  local generated="$2"

  # Check 1: File exists and not empty
  if [ ! -s "$generated" ]; then
    echo "❌ STOP: Output file is empty"
    return 1
  fi

  # Check 2: Size sanity (not >50% smaller)
  orig_size=$(wc -l < "$original")
  gen_size=$(wc -l < "$generated")
  if (( gen_size < orig_size / 2 )); then
    echo "⚠️  WARNING: Output 50%+ smaller ($orig_size → $gen_size lines)"
    echo "Possible truncation or data loss"
    return 1
  fi

  # Check 3: Syntax (if applicable)
  case "$original" in
    *.py) python -m py_compile "$generated" || return 1 ;;
    *.js) node --check "$generated" || return 1 ;;
    *.ts) tsc --noEmit "$generated" || return 1 ;;
  esac

  # Check 4: Critical pattern preservation
  # (customize per file type)
  if grep -q "CRITICAL:" "$original"; then
    if ! grep -q "CRITICAL:" "$generated"; then
      echo "❌ STOP: Critical section removed"
      return 1
    fi
  fi

  return 0
}

# Usage
if validate_gemini_output "auth.py" "/tmp/gemini-auth.py"; then
  echo "✅ Validation passed"
else
  echo "❌ Validation failed - review needed"
fi
```

---

## File Type-Specific Strategies

### Source Code (.py, .js, .ts, etc.)

**Safety:**
- Git safety net (always)
- Syntax validation (mandatory)
- Test execution (if available)
- Diff review (medium+ changes)

### Configuration Files (.env, .json, .yaml)

**Safety:**
- Manual backup (critical)
- Temp-first ALWAYS
- Key preservation check
- Schema validation (if available)

### Documentation (.md, .txt)

**Safety:**
- Direct execution OK
- Review for accuracy
- Check links/references

### Data Files (.csv, .json)

**Safety:**
- NEVER direct write
- Backup mandatory
- Checksum validation
- Row/record count verification

---

## Orchestrator Responsibilities Summary

**Claude's job as orchestrator:**

1. **Pre-execution:**
   - Evaluate file criticality
   - Check git status
   - Choose appropriate pattern
   - Structure safe prompt

2. **During execution:**
   - Monitor Gemini output
   - Check for errors/warnings

3. **Post-execution:**
   - Validate output integrity
   - Check scope boundaries
   - Verify no data loss
   - Run tests if available

4. **User communication:**
   - Report unexpected behavior
   - Show diffs for review
   - Request approval for risky changes
   - Provide rollback instructions

---

## Key Principle Revisited

**"Direction > Prohibition"** means:

- Don't block Gemini's capabilities
- Evaluate each operation individually
- Choose appropriate safety pattern
- Structure prompts for safe behavior
- Validate output before applying
- Trust but verify with safety nets

**Gemini can write files with --yolo safely IF:**
- Claude evaluates risk properly
- Appropriate pattern is chosen
- Git/backups provide reversibility
- Output is validated
- User reviews critical changes

---

*This framework enables powerful Gemini integration while maintaining safety through intelligent orchestration.*
