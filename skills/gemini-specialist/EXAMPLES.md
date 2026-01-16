# Gemini Specialist - Practical Examples

Real-world workflows demonstrating safe Gemini CLI integration.

---

## Example 1: Large Codebase Security Audit (Low Risk)

**Scenario:** Analyze 200+ files for security vulnerabilities

**Risk Assessment:**
- Files: Read-only analysis
- Output: New file (audit-report.md)
- Git: Any state OK
- Pattern: **Direct execution** ✅

**Execution:**
```bash
# Concatenate codebase
find src/ -name "*.py" -exec cat {} \; > /tmp/codebase.txt

# Gemini analyzes (1M context window)
gemini -p "Perform comprehensive security audit. Check for: SQL injection, XSS, hardcoded secrets, insecure dependencies. Output markdown report with severity levels." < /tmp/codebase.txt --yolo -o text > security-audit.md

# Claude reviews report, prioritizes fixes
cat security-audit.md
```

**Why safe:** New file, no overwrites, analysis only

---

## Example 2: Code Refactoring (Medium Risk)

**Scenario:** Refactor `auth.py` to use async/await

**Risk Assessment:**
- Files: Critical (auth.py)
- Operation: Modification
- Git: Should be clean
- Pattern: **Temp-first review** ⚠️

**Execution:**
```bash
# Pre-flight check
git status  # Ensure clean or commit first

# Gemini refactors to temp
gemini -p "Refactor this code to use async/await pattern. IMPORTANT: Preserve all existing function signatures, error handling, and logic flow. Output the complete refactored file." < auth.py --yolo -o text > /tmp/auth-refactored.py

# Claude validates before applying
echo "=== Changes Preview ==="
diff auth.py /tmp/auth-refactored.py

# Show to user for approval
echo "Review the changes above. Apply? (I'll wait for confirmation)"

# If approved:
cp /tmp/auth-refactored.py auth.py
git add auth.py
git commit -m "refactor: Convert auth.py to async/await (Gemini-assisted)"
```

**Why safe:** Temp file first, diff review, user approval, git commit

---

## Example 3: Architecture Planning (Zero Risk)

**Scenario:** Design microservices architecture for e-commerce platform

**Risk Assessment:**
- Files: New documentation
- Operation: Generation
- Git: N/A
- Pattern: **Direct execution** ✅

**Execution:**
```bash
# Gemini generates architecture plan
gemini -p "Design a microservices architecture for an e-commerce platform. Include: service boundaries, communication patterns (REST/gRPC/events), data storage per service, deployment strategy, and scaling considerations. Output detailed markdown document." --yolo -o text > architecture-plan.md

# Claude reads and uses plan for implementation
cat architecture-plan.md
# Claude can now implement services following the plan
```

**Why safe:** New file, planning only, no code modification

---

## Example 4: Documentation Synthesis (Low Risk)

**Scenario:** Review 50 README files and create unified getting-started guide

**Risk Assessment:**
- Files: Read-only (READMEs) + new file (output)
- Operation: Synthesis
- Git: Any state OK
- Pattern: **Direct execution** ✅

**Execution:**
```bash
# Concatenate all READMEs
find . -name "README.md" -exec echo "=== {} ===" \; -exec cat {} \; > /tmp/all-readmes.txt

# Gemini synthesizes
gemini -p "Read all these README files and create a unified 'Getting Started' guide. Include: installation, configuration, first steps, common workflows. Output markdown." < /tmp/all-readmes.txt --yolo -o text > GETTING-STARTED.md

# Claude reviews and may enhance
cat GETTING-STARTED.md
```

**Why safe:** Read-only input, new output file

---

## Example 5: Config File Update (High Risk)

**Scenario:** Update `.env.example` with new variables from codebase analysis

**Risk Assessment:**
- Files: Config file (HIGH CRITICALITY)
- Operation: Modification
- Git: Must commit first
- Pattern: **Git safety net + temp-first** 🔴

**Execution:**
```bash
# CRITICAL: Backup first
git add .env.example
git commit -m "backup: .env.example before Gemini update"

# Extract current config
cp .env.example /tmp/env-current.txt

# Gemini analyzes code for new env vars
find src/ -name "*.py" -exec cat {} \; > /tmp/codebase.txt

gemini -p "Analyze this codebase and identify all environment variables used. Compare with the current .env.example file. Output ONLY the new variables that should be added, with descriptions." < /tmp/codebase.txt --yolo -o text > /tmp/new-env-vars.txt

# Claude reviews and manually adds (NOT direct write)
cat /tmp/new-env-vars.txt

# Claude appends to .env.example manually after validation
# If something goes wrong: git restore .env.example
```

**Why safe:** Git commit first, manual application by Claude, easy rollback

---

## Example 6: Cross-Validation (Second Opinion)

**Scenario:** Claude wrote complex algorithm, get Gemini's review

**Risk Assessment:**
- Files: Read-only (algorithm.py)
- Operation: Analysis/critique
- Git: Any state OK
- Pattern: **Direct execution** ✅

**Execution:**
```bash
# After Claude implements algorithm
cat algorithm.py

# Gemini reviews
gemini -p "Review this algorithm for: correctness, edge cases, performance issues, potential bugs. Provide specific suggestions with line numbers." < algorithm.py --yolo -o text > /tmp/gemini-review.txt

# Claude reads review and refines code
cat /tmp/gemini-review.txt
# Claude applies improvements based on feedback
```

**Why safe:** Read-only analysis, Claude decides which feedback to apply

---

## Pattern Selection Matrix

| Scenario | File Type | Operation | Pattern | Why |
|----------|-----------|-----------|---------|-----|
| Security audit | Multiple (read) | Analysis | Direct | No writes |
| Code refactoring | Critical file | Modification | Temp-first | Review needed |
| Architecture plan | New file | Generation | Direct | No overwrites |
| Doc synthesis | Multiple (read) | Synthesis | Direct | New output |
| Config update | Config file | Modification | Git + Temp | Critical file |
| Code review | Any (read) | Critique | Direct | Analysis only |

---

## Common Gemini Prompt Patterns

### Analysis Prompt
```bash
gemini -p "Analyze [topic]. Focus on [aspects]. Output [format]." < input --yolo -o text
```

### Generation Prompt
```bash
gemini -p "Generate [artifact]. Requirements: [list]. Output [format]." --yolo -o text > output
```

### Refactoring Prompt
```bash
gemini -p "Refactor [file] to [pattern]. PRESERVE: [constraints]. Output complete file." < file --yolo -o text > /tmp/refactored
```

### Review Prompt
```bash
gemini -p "Review [code] for [criteria]. Provide specific feedback with line numbers." < file --yolo -o text
```

---

## Tips for Safe Prompts

1. **Be specific:** "Extract function names" > "Analyze code"
2. **State constraints:** "Preserve all function signatures"
3. **Define output:** "Output complete file" vs "Output diff only"
4. **Set boundaries:** "Only modify lines 10-50"
5. **Request validation:** "Include test cases in output"

---

## When Claude Should Intervene

**Red flags** (Claude stops and asks user):
- Gemini output is incomplete/truncated
- Gemini hallucinated code/functionality
- Gemini removed critical sections
- Output doesn't match prompt scope
- Syntax errors in generated code

**Claude's job:**
- Validate output integrity
- Compare scope (did Gemini stay in bounds?)
- Check for data loss
- Verify syntax/structure
- Report issues to user before applying

---

*These examples demonstrate the "Direction > Prohibition" philosophy. Claude evaluates risk and chooses patterns intelligently.*
