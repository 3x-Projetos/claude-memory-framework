# Teams Framework - Orquestração Multi-Agente

## 🎯 Conceitos Fundamentais

### Definições

**Persona/Agent Definition (Definição)**
- Arquivo GUIDE.md descrevendo expertise, background, responsabilidades
- Define "quem é" o agente e "o que sabe fazer"
- Contém frameworks, checklists, exemplos
- Exemplo: `backend-validator/GUIDE.md`

**Worker/Agent Instance (Instância)**
- Execução paralela de uma tarefa usando Task tool
- Pode usar uma persona definida ou ser genérico
- Múltiplos workers podem rodar simultaneamente
- Exemplo: `Task(subagent_type="general-purpose", prompt="You are backend-validator...")`

**Team (Equipe)**
- Organização estruturada de múltiplos agentes/workers
- Coordenação sequencial ou paralela para resolver problema complexo
- Define workflow de comunicação entre agentes
- Pode ter múltiplas rodadas de interação

---

## 🏗️ Arquiteturas de Teams

### 1. Sequential Team (Equipe Sequencial)

**Quando usar**: Etapas dependem de resultados anteriores

**Estrutura**:
```
User Request
    ↓
[Agent 1: Analysis] → Results 1
    ↓
[Agent 2: Design] → Results 2
    ↓
[Agent 3: Implementation] → Results 3
    ↓
[Agent 4: Validation] → Final Output
```

**Exemplo - Feature Development Team**:
```markdown
1. tech-lead-coordinator: Analisa requisitos, identifica riscos
   → Output: Architectural decisions, risk assessment

2. backend-validator: Valida design do backend
   → Input: Architectural decisions
   → Output: Backend implementation plan

3. frontend-validator: Valida design do frontend
   → Input: Architectural decisions
   → Output: Frontend implementation plan

4. tech-lead-coordinator: Review final
   → Input: Both implementation plans
   → Output: Go/No-go decision
```

**Implementação**:
```
Round 1: Analysis
- Call Task(tech-lead-coordinator)
- Wait for results

Round 2: Parallel validation
- Single message with TWO Task calls
- Wait for both

Round 3: Final review
- Call Task(tech-lead-coordinator)
```

---

### 2. Parallel Team (Equipe Paralela)

**Quando usar**: Tarefas independentes que podem rodar simultaneamente

**Estrutura**:
```
User Request
    ↓
    ├─→ [Agent 1: Task A] ─→ Result A
    ├─→ [Agent 2: Task B] ─→ Result B
    ├─→ [Agent 3: Task C] ─→ Result C
    └─→ [Agent 4: Task D] ─→ Result D
    ↓
[Coordinator: Synthesis] → Final Output
```

**Exemplo - Multi-File Validation Team**:
```markdown
Parallel validation of multiple files:
1. backend-validator: Validates routes/commands.ts
2. backend-validator: Validates routes/history.ts
3. backend-validator: Validates services/golfleet.ts
4. frontend-validator: Validates hooks/useCommands.ts

After all complete:
5. tech-lead-coordinator: Synthesizes all findings
```

**Implementação**:
```
Single message with MULTIPLE Task calls:
- All 4 validators run in parallel
- Wait for all to complete
- Then call tech-lead-coordinator for synthesis
```

---

### 3. Hierarchical Team (Equipe Hierárquica)

**Quando usar**: Problema complexo com sub-problemas

**Estrutura**:
```
[Coordinator/Manager]
    ↓
    ├─→ [Team Lead 1]
    │       ├─→ [Worker A]
    │       └─→ [Worker B]
    ├─→ [Team Lead 2]
    │       ├─→ [Worker C]
    │       └─→ [Worker D]
    └─→ [Quality Assurance]
    ↓
Final Output
```

**Exemplo - Full Sprint Implementation Team**:
```markdown
1. tech-lead-coordinator (Manager): Breaks down sprint into tasks
   → Output: Task list with dependencies

2. Backend Team (backend-validator leads):
   - Spawns workers for routes, services, tests
   → Output: Backend implementation complete

3. Frontend Team (frontend-validator leads):
   - Spawns workers for hooks, components, tests
   → Output: Frontend implementation complete

4. Integration Team (tech-lead-coordinator):
   - Reviews both implementations
   - Runs integration tests
   → Output: Sprint complete
```

---

### 4. Iterative Team (Equipe Iterativa)

**Quando usar**: Problema requer refinamento progressivo

**Estrutura**:
```
[Agent 1: Generator] → Draft v1
    ↓
[Agent 2: Critic] → Feedback v1
    ↓
[Agent 1: Generator] → Draft v2
    ↓
[Agent 2: Critic] → Feedback v2
    ↓
... (até convergência)
    ↓
Final Output
```

**Exemplo - API Design Refinement Team**:
```markdown
Round 1:
- api-debugger: Analyzes Postman + Python script, proposes endpoint design
- backend-validator: Reviews design, identifies issues

Round 2 (if issues found):
- api-debugger: Refines design based on feedback
- backend-validator: Re-validates

Continue until backend-validator approves
```

---

### 5. Hub-and-Spoke Team (Equipe Estrela)

**Quando usar**: Coordenador central precisa consultar múltiplos especialistas

**Estrutura**:
```
        [Specialist 1]
             ↓
        [Specialist 2] ←→ [Hub/Coordinator] ←→ [Specialist 4]
             ↓
        [Specialist 3]
             ↓
        Final Decision
```

**Exemplo - Pre-Deployment Review Team**:
```markdown
Hub: tech-lead-coordinator asks questions to specialists

Round 1 (Parallel queries):
- backend-validator: Is backend production-ready?
- frontend-validator: Is frontend production-ready?
- test-specialist: Is test coverage sufficient?
- ui-specialist: Is UI polished?

Hub receives all answers, identifies gaps

Round 2 (If gaps, targeted follow-ups):
- backend-validator: Fix critical issue X
- Hub waits for fix

Round 3 (Final check):
- Hub makes go/no-go decision
```

---

## 📋 Team Patterns por Tipo de Tarefa

### Feature Development
**Pattern**: Sequential → Parallel → Sequential
```
1. tech-lead: Plan architecture (Sequential)
2. backend-validator + frontend-validator: Validate designs (Parallel)
3. Implement code (Human or AI)
4. backend-validator + frontend-validator: Validate implementations (Parallel)
5. tech-lead: Final review (Sequential)
```

### Bug Investigation
**Pattern**: Parallel → Sequential
```
1. Multiple agents investigate different areas (Parallel):
   - backend-validator: Check API logs
   - frontend-validator: Check browser console
   - ux-specialist: Reproduce bug flow
2. tech-lead: Synthesize findings, identify root cause (Sequential)
3. Relevant validator: Verify fix (Sequential)
```

### Code Review
**Pattern**: Parallel → Hierarchical
```
1. Multiple validators review different aspects (Parallel):
   - backend-validator: Security, performance
   - frontend-validator: Accessibility, UX
   - test-specialist: Test coverage
2. tech-lead: Aggregate feedback, prioritize (Hierarchical)
```

### API Debugging
**Pattern**: Sequential → Iterative
```
1. api-debugger: Compare implementations (Sequential)
2. Iterative refinement:
   - api-debugger: Proposes fix
   - backend-validator: Validates fix
   - Repeat until approved
```

---

## 🛠️ Implementação Prática

### Exemplo Real: Sprint 3 Command Sending (O que fizemos)

**Team usado**: Sequential → Parallel (Iterative)

**Round 1 - Problem Analysis (Sequential)**:
```
User reported: "Buttons redirect to login instead of sending commands"

Action: Created ux-specialist agent
Called: Task(ux-specialist, "analyze authentication bug")
Result: Identified race conditions in token storage
```

**Round 2 - Layout Issues (Parallel)**:
```
User reported: "Layout has issues - margins, scroll, etc"

Action: Created ui-specialist agent
Called TWO Tasks in parallel:
- Task(ui-specialist, "analyze layout issues")
- Task(ux-specialist, "analyze user flow")

Result: Both identified AppLayout.tsx as root cause
```

**Round 3 - API Issues (Iterative)**:
```
User: "Commands still fail with 403"

Round 3a:
- Called: Task(backend-validator, "investigate 403 errors")
- Result: Found AWS API Gateway issue

Round 3b (after first fix failed):
- Created: api-debugger agent
- Called: Task(api-debugger, "compare Postman + Python + implementation")
- Result: Found THREE critical issues (endpoint, Bearer, casing)

Round 3c (verification):
- Applied fixes
- Ready for user testing
```

**Team Effectiveness**:
- ✅ ui-specialist: Found root cause of layout in 1 try
- ✅ api-debugger: Found ALL 3 API issues in 1 comprehensive analysis
- ✅ Avoided going in circles by using specialized agents

---

## 📐 Workflow Decision Tree

```
New Task Arrives
    ↓
Is it exploratory/research?
    ├─ YES → Use Explore agent (single agent)
    └─ NO ↓

Does it have multiple independent subtasks?
    ├─ YES → Parallel Team
    └─ NO ↓

Does it require iterative refinement?
    ├─ YES → Iterative Team
    └─ NO ↓

Does it have sequential dependencies?
    ├─ YES → Sequential Team
    └─ NO ↓

Is there a coordinating agent + specialists?
    ├─ YES → Hub-and-Spoke Team
    └─ NO ↓

Are you UNCERTAIN which pattern to use?
    ├─ YES → ASK USER for guidance
    │         User can suggest or delegate decision
    └─ NO → Single specialized agent
```

**⚠️ IMPORTANT - When Uncertain About Team Pattern**:

**ALWAYS validate with user when uncertain**. Present options clearly:
- "I see this could be [Pattern A] because [reason] or [Pattern B] because [reason]. Which would you prefer?"
- "This task seems to need [Pattern X]. Does that sound right, or would you suggest a different approach?"
- User can either:
  - Provide specific guidance ("Use Pattern A")
  - Suggest alternative approach ("Actually, try Pattern C")
  - Delegate decision back ("Your call, go with what makes sense")

**Never assume** when multiple patterns could work. User context often reveals the best choice.

---

## 🎓 Lições Aprendidas (Sprint 3)

### O que funcionou bem:
1. **Criar agentes especializados antes de trabalhar**
   - api-debugger encontrou todos os issues em 1 análise
   - ui-specialist/ux-specialist separaram concerns claramente

2. **Executar validações em paralelo**
   - Economiza tempo
   - Cada agente foca em sua expertise

3. **Iteração com feedback**
   - api-debugger → backend-validator loop
   - Cada round refinava a solução

### O que evitar:
1. **Trabalhar diretamente sem agentes**
   - Rodamos em círculos tentando fixes sem análise estruturada
   - Perdemos contexto com múltiplas tentativas

2. **Não documentar decisões dos agentes**
   - Importante salvar outputs para referência futura

3. **Ignorar a necessidade de novos agentes**
   - api-debugger só foi criado depois de várias tentativas
   - Deveria ter sido criado no primeiro 403 error

---

## 📝 Templates de Chamadas

### Template: Parallel Validation Team
```
# Objetivo: Validar múltiplos arquivos modificados

Round 1 - Parallel Execution:
Send ONE message with MULTIPLE Task calls:

Task 1: backend-validator validates file A
Task 2: backend-validator validates file B
Task 3: frontend-validator validates file C
Task 4: test-specialist validates test coverage

Wait for all 4 to complete.

Round 2 - Synthesis:
Task: tech-lead-coordinator
Prompt: "Review all 4 validation reports. Prioritize issues. Create action plan."
```

### Template: Iterative Refinement Team
```
# Objetivo: Refinar solução até aprovação

Round 1:
- specialist-A: Proposes solution
- Wait for output

Round 2:
- specialist-B: Reviews solution from Round 1
- If approved → Done
- If issues → Continue to Round 3

Round 3:
- specialist-A: Refines based on Round 2 feedback
- Go back to Round 2

Max 3-5 iterations, then escalate to human.
```

### Template: Hub-and-Spoke Review
```
# Objetivo: Pre-deployment checklist

Round 1 - Parallel Queries:
Send ONE message with ALL specialist calls:
- backend-validator: Production readiness?
- frontend-validator: UX/Accessibility ready?
- test-specialist: Coverage sufficient?
- ui-specialist: Visual polish done?

Round 2 - Coordinator Decision:
Task: tech-lead-coordinator
Input: All 4 reports from Round 1
Output: Go/No-go + action items if No-go

If No-go:
Round 3 - Targeted Fixes:
- Address specific issues
- Re-validate with relevant specialist
- Return to Round 2
```

---

## 🔄 Integration com CLAUDE.md

A documentação em `.claude/CLAUDE.md` deve referenciar este framework:

```markdown
## 🤖 CRITICAL: Agent-First Development

**Workflow**:
1. Identify task type
2. Check `.claude/docs/TEAMS-FRAMEWORK.md` for appropriate team pattern
3. Create any missing agent definitions
4. Execute team workflow
5. Synthesize results

**Team Patterns**: See `TEAMS-FRAMEWORK.md` for:
- Sequential Teams
- Parallel Teams
- Hierarchical Teams
- Iterative Teams
- Hub-and-Spoke Teams
```

---

## ✅ Checklist de Uso de Teams

Antes de executar qualquer tarefa complexa:

- [ ] Identifiquei o tipo de tarefa?
- [ ] Consultei TEAMS-FRAMEWORK.md para pattern apropriado?
- [ ] Verifiquei quais agent personas existem em `.claude/agents/`?
- [ ] Criei novos agents se necessário?
- [ ] Defini ordem de execução (paralelo vs sequencial)?
- [ ] Planejei quantas rounds de interação esperar?
- [ ] Defini critérios de sucesso/convergência?

Durante execução:

- [ ] Estou salvando outputs dos agents para referência?
- [ ] Estou sintetizando resultados entre rounds?
- [ ] Estou respeitando o máximo de 3-5 iterations antes de escalar?

Após conclusão:

- [ ] Documentei qual team pattern foi usado?
- [ ] Documentei o que funcionou/não funcionou?
- [ ] Atualizei agent personas se aprendi algo novo?

---

## 🎯 Próximos Passos

1. **Atualizar CLAUDE.md** com referência a este framework
2. **Criar templates práticos** de team workflows mais usados
3. **Documentar métricas** de efetividade de cada pattern
4. **Revisar sprints futuros** usando team patterns

---

**Versão**: 1.0
**Última atualização**: 2026-01-16
**Autor**: Luis Romano + Claude Sonnet 4.5
