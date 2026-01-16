# Planejamento Revisado: Videotelemetria UI com Teams Framework

## 🎯 Visão Geral

Este documento revisa o planejamento original aplicando o **Teams Framework** para cada sprint, definindo:
- Qual team pattern usar
- Quais agents/personas envolver
- Workflow de coordenação
- Critérios de sucesso

---

## ✅ Sprint 3: COMPLETO - Envio de Comandos Básicos

**Status**: 🟢 IMPLEMENTADO (aguardando teste do usuário)

### Team Pattern Usado
**Iterative Team** (api-debugger ↔ backend-validator)

### Workflow Real
1. **Round 1**: ux-specialist investigou bug de autenticação
2. **Round 2**: ui-specialist + ux-specialist analisaram layout (Parallel)
3. **Round 3a**: backend-validator investigou 403 errors
4. **Round 3b**: api-debugger comparou Postman + Python + código (SOLUÇÃO ENCONTRADA)
5. **Round 3c**: Aplicadas correções

### Lições Aprendidas
✅ **Funcionou**: Criar api-debugger resolveu problema em 1 análise
✅ **Funcionou**: Parallel team para UI/UX foi eficiente
❌ **Evitar**: Rounds 1-3a foram tentativas sem estrutura clara

### Adendo Pendente
- [ ] Adicionar botão "Get MAC Address" em QuickCommands

---

## 🎯 Sprint 4: Respostas e Comandos Multi-Step

**Objetivo**: Obter respostas de comandos + executar comandos sequenciais

### Team Pattern Recomendado
**Sequential Team** → **Parallel Validation**

```
Round 1: Planning (Sequential)
├─ tech-lead-coordinator: Analisa Sprint 4 requirements
│  Output: Architecture decisions, task breakdown
│
Round 2: Design (Parallel)
├─ backend-validator: Valida Events API integration design
└─ backend-validator: Valida Multi-Step Orchestrator design
│  Wait for both
│
Round 3: Implementation (Human)
├─ Implementar backend/src/routes/events.ts
├─ Implementar backend/src/services/commandOrchestrator.ts
├─ Implementar frontend/src/components/ResponseViewer.tsx
├─ Implementar frontend/src/components/MultiStepProgress.tsx
│
Round 4: Validation (Parallel)
├─ backend-validator: Valida events.ts + orchestrator.ts
├─ frontend-validator: Valida ResponseViewer + MultiStepProgress
└─ api-debugger: Valida integração com Golfleet Events API
│  Wait for all
│
Round 5: Final Review (Sequential)
└─ tech-lead-coordinator: Approval + checklist
```

### Agents Necessários
**Existentes**:
- ✅ tech-lead-coordinator
- ✅ backend-validator
- ✅ frontend-validator
- ✅ api-debugger

**Novos** (se necessário):
- ❓ events-specialist: Especialista em parsing de eventos (avaliar necessidade)

### Critérios de Sucesso
- [ ] Parser de eventos extrai response corretamente
- [ ] Multi-step commands executam em ordem (tar → upload)
- [ ] Progress indicator mostra estado de cada step
- [ ] Response viewer mostra dados formatados
- [ ] Backend-validator aprova error handling
- [ ] Frontend-validator aprova UX de multi-step

### Arquivos Críticos
**Backend (Criar)**:
- `backend/src/routes/events.ts`
- `backend/src/services/commandOrchestrator.ts`

**Frontend (Criar)**:
- `frontend/src/components/ResponseViewer.tsx`
- `frontend/src/components/MultiStepProgress.tsx`

**Shared (Modificar)**:
- `shared/types.ts` (Event, MultiStepCommand types)

### Riscos Identificados
1. **Alto**: Events API pode ter formato diferente do esperado
   - Mitigação: api-debugger compara Postman antes de implementar
2. **Médio**: Multi-step pode falhar no meio
   - Mitigação: Rollback mechanism + partial success handling

---

## 🎯 Sprint 5: Multi-Device Operations

**Objetivo**: Enviar comandos para múltiplos devices em paralelo

### Team Pattern Recomendado
**Parallel Team** → **Hub-and-Spoke Validation**

```
Round 1: Planning (Sequential)
└─ tech-lead-coordinator: Analisa bulk operations requirements
│  Output: Concurrency limits, error handling strategy
│
Round 2: Implementation (Human)
├─ Implementar backend/src/routes/commands.ts (bulk endpoint)
├─ Implementar frontend/src/pages/MultiDevice.tsx (reescrever)
├─ Implementar frontend/src/components/BulkProgressTable.tsx
│
Round 3: Validation (Parallel + Hub)
├─ backend-validator: Valida bulk endpoint (rate limiting, concurrency)
├─ frontend-validator: Valida MultiDevice UX (progress tracking, retry)
├─ ux-specialist: Valida fluxo de bulk commands (error recovery)
└─ ui-specialist: Valida progress table (layout, readability)
│  Wait for all
│
Round 4: Synthesis (Hub-and-Spoke)
└─ tech-lead-coordinator: Agrega findings, prioriza fixes
   Hub consulta specialists para clarificações
```

### Agents Necessários
**Existentes**:
- ✅ tech-lead-coordinator (Hub)
- ✅ backend-validator
- ✅ frontend-validator
- ✅ ux-specialist
- ✅ ui-specialist

**Novos**: Nenhum

### Critérios de Sucesso
- [ ] Bulk endpoint aceita max 50 IMEIs
- [ ] Promise.all com error handling individual
- [ ] Progress table mostra status real-time
- [ ] Retry funciona para failed devices
- [ ] Export CSV funciona
- [ ] Rate limiting implementado (30 req/min)

### Arquivos Críticos
**Backend (Modificar)**:
- `backend/src/routes/commands.ts` (adicionar POST /bulk)

**Frontend (Reescrever)**:
- `frontend/src/pages/MultiDevice.tsx`

**Frontend (Criar)**:
- `frontend/src/components/BulkProgressTable.tsx`
- `frontend/src/hooks/useBulkCommands.ts`

### Riscos Identificados
1. **Alto**: 50 requests simultâneos podem sobrecarregar API
   - Mitigação: Batch processing (10 por vez) + rate limiting
2. **Médio**: Progress tracking pode ficar dessincronizado
   - Mitigação: WebSocket ou polling inteligente

---

## 🎯 Sprint 6: Mídia e Arquivos

**Objetivo**: Solicitar mídia (image/video) e baixar arquivos do device

### Team Pattern Recomendado
**Hierarchical Team** (Backend Team + Frontend Team)

```
Round 1: Planning (Sequential)
└─ tech-lead-coordinator: Define arquitectura de media handling
│  Output: S3 integration plan, CORS strategy, file size limits
│
Round 2: Backend Team (Hierarchical)
├─ Backend Lead: backend-validator
│  ├─ Worker 1: Implement media request endpoint
│  ├─ Worker 2: Implement file download proxy
│  └─ Worker 3: Validate with api-debugger
│  Output: Backend media API complete
│
Round 3: Frontend Team (Hierarchical)
├─ Frontend Lead: frontend-validator
│  ├─ Worker 1: Implement MediaRequestForm
│  ├─ Worker 2: Implement FileBrowser
│  └─ Worker 3: Validate with ui-specialist + ux-specialist
│  Output: Frontend media UI complete
│
Round 4: Integration (Sequential)
└─ tech-lead-coordinator: Testa fluxo completo, aprova
```

### Agents Necessários
**Existentes**:
- ✅ tech-lead-coordinator
- ✅ backend-validator
- ✅ frontend-validator
- ✅ ui-specialist
- ✅ ux-specialist
- ✅ api-debugger

**Novos** (se necessário):
- ❓ media-specialist: Valida formatos, codecs, CORS (avaliar necessidade)

### Critérios de Sucesso
- [ ] Request de vídeo 3min funciona
- [ ] Download de databases.tar funciona
- [ ] CORS configurado corretamente
- [ ] File size limits respeitados
- [ ] Progress indicator durante upload/download
- [ ] Error handling para timeouts

### Arquivos Críticos
**Backend (Criar)**:
- `backend/src/routes/media.ts`
- `backend/src/routes/files.ts`

**Frontend (Criar)**:
- `frontend/src/components/MediaRequestForm.tsx`
- `frontend/src/components/FileBrowser.tsx`

### Riscos Identificados
1. **Alto**: CORS issues com S3
   - Mitigação: Backend proxy para evitar CORS
2. **Médio**: Vídeos grandes podem timeout
   - Mitigação: Streaming ao invés de download completo

---

## 🎯 Sprint 7: Polimento e Produção

**Objetivo**: Production-ready (rate limiting, logging, testing, docs)

### Team Pattern Recomendado
**Hub-and-Spoke Review** (Pre-deployment checklist)

```
Round 1: Parallel Specialists Assessment
├─ backend-validator: Production readiness?
│  ├─ Rate limiting OK?
│  ├─ Logging structured?
│  ├─ Error handling global?
│  └─ Health checks working?
│
├─ frontend-validator: UX/Accessibility ready?
│  ├─ Error boundaries?
│  ├─ Loading states?
│  ├─ Keyboard navigation?
│  └─ Screen reader support?
│
├─ test-specialist: Coverage sufficient?
│  ├─ Unit tests > 70%?
│  ├─ Integration tests critical paths?
│  └─ E2E tests key flows?
│
├─ ui-specialist: Visual polish done?
│  ├─ No layout bugs?
│  ├─ Consistent spacing?
│  └─ Mobile responsive?
│
└─ ux-specialist: User flows smooth?
   ├─ Error recovery clear?
   ├─ Success feedback immediate?
   └─ No dead ends?

Wait for all 5 specialists

Round 2: Hub Synthesis (tech-lead-coordinator)
├─ Aggregate all 5 reports
├─ Prioritize issues (Critical/Medium/Low)
└─ Create action plan

Round 3: Targeted Fixes (if needed)
├─ Address critical issues
├─ Re-validate with relevant specialist
└─ Return to Round 2 if needed

Round 4: Final Go/No-Go Decision
└─ tech-lead-coordinator: Deployment approval
```

### Agents Necessários
**Existentes**:
- ✅ tech-lead-coordinator (Hub)
- ✅ backend-validator
- ✅ frontend-validator
- ✅ test-specialist
- ✅ ui-specialist
- ✅ ux-specialist

**Novos**: Nenhum

### Critérios de Sucesso
- [ ] All 5 specialists approve
- [ ] No critical issues remaining
- [ ] Test coverage > 70%
- [ ] Documentation complete (API docs, user guide, deployment guide)
- [ ] CI/CD pipeline working
- [ ] Monitoring configured (Sentry, metrics)

### Checklist de Produção
**Backend**:
- [ ] Rate limiting (30 req/min global, 10 req/min /commands/send)
- [ ] Winston logger com rotation diária
- [ ] Global error handler
- [ ] Health checks (/health/live, /health/ready)
- [ ] Environment validation no startup

**Frontend**:
- [ ] Error boundaries
- [ ] Skeleton loaders
- [ ] Code splitting
- [ ] Lazy loading
- [ ] ARIA labels

**Infrastructure**:
- [ ] Dockerfile backend + frontend
- [ ] docker-compose.yml
- [ ] GitHub Actions CI/CD
- [ ] Sentry integration
- [ ] Prometheus metrics

**Testing**:
- [ ] Backend unit tests > 70%
- [ ] Frontend unit tests > 70%
- [ ] Integration tests
- [ ] E2E tests (Playwright)

**Documentation**:
- [ ] API docs (Swagger)
- [ ] User guide
- [ ] Deployment guide

---

## 📊 Resumo de Teams por Sprint

| Sprint | Team Pattern | Agents Envolvidos | Rounds Estimados |
|--------|-------------|-------------------|------------------|
| Sprint 3 ✅ | Iterative | ui, ux, api-debugger, backend-validator | 3-5 |
| Sprint 4 🔄 | Sequential → Parallel | tech-lead, backend-validator, frontend-validator, api-debugger | 5 |
| Sprint 5 🔄 | Parallel → Hub-and-Spoke | tech-lead, backend, frontend, ui, ux | 4 |
| Sprint 6 🔄 | Hierarchical | tech-lead, backend, frontend, ui, ux, api-debugger | 4 |
| Sprint 7 🔄 | Hub-and-Spoke | tech-lead (hub), 5 specialists | 4 |

---

## 🎯 Workflow Geral para Cada Sprint

### Antes de Iniciar
1. **Consultar TEAMS-FRAMEWORK.md** para escolher pattern
2. **Verificar agents disponíveis** em `.claude/agents/`
3. **Criar novos agents** se necessário
4. **Definir critérios de sucesso** claros

### Durante Sprint
1. **Round 1**: Sempre começar com planejamento (tech-lead)
2. **Rounds intermediários**: Validações paralelas quando possível
3. **Round final**: Sempre synthesis/approval (tech-lead)
4. **Documentar outputs** de cada agent

### Após Sprint
1. **Atualizar este documento** com lições aprendidas
2. **Refinar agent personas** com novos insights
3. **Commitar mudanças** no plano

---

## 🔄 Revisão Contínua

Este planejamento deve ser revisado:
- ✅ Após cada sprint completo
- ✅ Quando novos agents forem criados
- ✅ Quando padrões novos emergirem
- ✅ Quando user feedback sugerir mudanças

**Última revisão**: 2026-01-16 (após Sprint 3)
**Próxima revisão**: Após Sprint 4 completo

---

**Versão**: 1.0
**Autor**: Luis Romano + Claude Sonnet 4.5
