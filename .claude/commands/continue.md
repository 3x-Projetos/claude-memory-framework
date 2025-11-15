---
description: Continua de onde a última sessão parou
---

Retomando trabalho com sistema de memória hierárquica.

## Passos

### 1. Executar redação de PII
```bash
python .claude/redact-pii.py
```
Isso gera `~/.claude-memory/global-memory.safe.md` (PII redacted para transmissão segura)

### 2. Carregar memória global (redacted)
Ler `~/.claude-memory/global-memory.safe.md`:
- User Profile (preferências, working style, tech stack)
- Collaboration Patterns (como trabalhar com você)
- Projects Context (projetos ativos)
- Recurring Architecture Decisions
- Meta-Learnings

### 3. Carregar working memory local
Ler `.session-state.md`:
- Última sessão (data e resumo)
- Pendências ativas
- Arquivos principais
- Próximos passos

### 4. Carregar contexto recente hierárquico
Seguir hierarquia (do mais recente ao mais agregado):

a) **Log diário mais recente** (se hoje já tem sessão):
   - Ler `logs/daily/YYYY.MM.DD.md` (hoje)

b) **Resumo semanal** (contexto da semana):
   - Buscar último arquivo em `logs/weekly/`
   - Ler para entender contexto da semana

c) **Resumo mensal** (contexto de longo prazo):
   - Buscar último arquivo em `logs/monthly/`
   - Ler para entender tendências do mês

**Economia de tokens**:
- Working memory: ~50 linhas
- Global memory (safe): ~150 linhas
- Weekly: ~100 linhas
- Monthly: ~30 linhas
- **Total: ~330 linhas** vs ~5.000+ linhas de logs brutos

### 5. Detectar agregações pendentes
Executar detecção automática:

a) **Weekly agregation pending?**
   - Verificar se última semana completa tem resumo em `logs/weekly/`
   - Se NÃO: Informar "⚠️ Semana X de YYYY sem resumo. Recomendo executar `/aggregate week`"

b) **Monthly agregation pending?**
   - Verificar se último mês completo tem resumo em `logs/monthly/`
   - Se NÃO: Informar "⚠️ Mês YYYY.MM sem resumo. Recomendo executar `/aggregate month`"

### 6. Apresentar contexto ao usuário
Formato conciso:

```
**Retomando**: [Data da última sessão] - [Resumo 1 linha]

**Pendências Ativas**:
- [ ] Tarefa 1
- [ ] Tarefa 2
...

(Se houver) **⚠️ Agregações Pendentes**:
- Semana X de YYYY: Execute `/aggregate week`
- Mês YYYY.MM: Execute `/aggregate month`

Continuando de onde paramos...
```

### 7. Lembrete final
"Use `/end` para registrar esta sessão ao finalizar."

---

## Notas
- Modo **continuação**: Foco em retomar trabalho anterior
- Carregamento hierárquico: Economia massiva de tokens
- Detecção automática: Sistema sugere agregações quando necessário
- Conciso: Informações essenciais, sem verbosidade
