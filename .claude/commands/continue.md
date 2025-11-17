---
description: Continua de onde a última sessão parou
---

Retomando trabalho com sistema de memória hierárquica.

**M010.1 - Multi-Resolution Memory**: Quick memories para startup rápido (~84% economia vs v2.0).

## Passos

### 1. Executar redação de PII
```bash
python .claude/redact-pii.py
```
Gera `global-memory.safe.md` + `global-memory.quick.md` (resumida, safe)

### 2. Ler APENAS session-state (seções essenciais)
Ler `.session-state.md` (primeiras ~40 linhas):
- Última sessão (linhas 2-3)
- **Aggregation Status** (linhas 8-14) ← NOVO
- Active Projects (top 3-4)
- Pendências Ativas (top 5-7)

**NÃO carregar ainda**: Global memory, logs, project contexts
Carregar SOB DEMANDA após escolha do usuário.

### 3. Verificar gatilhos temporais (NOVO - M010.1)
```python
# Obter data atual
import datetime
hoje = datetime.datetime.now()
dia_semana = hoje.weekday()  # 0=Mon, 4=Fri, 5=Sat
ultimo_dia_mes = (hoje.replace(day=28) + datetime.timedelta(days=4)).replace(day=1) - datetime.timedelta(days=1)
eh_ultimo_dia = hoje.day == ultimo_dia_mes.day

# Gatilhos
alerta_semanal = "⏰ Hoje é sexta! Recomendo executar `/aggregate week` ao final do dia." if dia_semana == 4 else ""
alerta_mensal = "⏰ Último dia do mês! Recomendo executar `/aggregate month` ao final do dia." if eh_ultimo_dia else ""
```

### 4. Apresentar resumo conciso
Formato:

```
**Retomando**: [Data última sessão] - [Resumo 1 linha]

**Aggregations**:
- Weekly: [status] [última semana agregada]
- Monthly: [status] [último mês agregado]

[Se sexta] ⏰ Hoje é sexta! Recomendo `/aggregate week` ao final do dia.
[Se último dia] ⏰ Último dia do mês! Recomendo `/aggregate month` ao final do dia.

**Active Projects**:
1. [Project 1] - [Status emoji] [Status]
2. [Project 2] - [Status emoji] [Status]
3. [Project 3] - [Status emoji] [Status]

**Top Pendências**:
- [ ] Pendência 1
- [ ] Pendência 2
- [ ] Pendência 3

---

Qual projeto você quer trabalhar?
[1] [Nome Projeto 1]
[2] [Nome Projeto 2]
[3] [Nome Projeto 3]
[outro] Ver todos os projetos
[nenhum] Exploração livre (multi-projeto)
```

### 5. AGUARDAR escolha do usuário

**IMPORTANTE**: Pausar aqui. Não carregar mais contexto até usuário responder.

### 6. Carregar contexto sob demanda

**Se usuário escolher projeto específico (1, 2, ou 3)**:
```markdown
1. Read: ~/.claude-memory/global-memory.quick.md (~50 linhas)
2. Read: .projects/[project-name]/.context.quick.md (~30 linhas)
3. Executar /switch [project-name] (atualiza Current Focus)
4. Apresentar "Next Actions (Top 3)" do projeto

Total: ~120 linhas (~1.400 tokens)
```

**Se usuário escolher "outro"**:
```markdown
1. Executar /projects (lista todos por categoria)
2. Aguardar nova escolha
3. Repetir fluxo "projeto específico"
```

**Se usuário escolher "nenhum" (exploração/multi-projeto)**:
```markdown
1. Read: ~/.claude-memory/global-memory.quick.md (~50 linhas)
2. Modo multi-projeto ativado (sem carregar logs - economizar tokens)

Total: ~90 linhas (~1.000 tokens)
```

### 7. Lembrete final
"Use `/end` para registrar esta sessão ao finalizar."

---

## Economia M010.1

**Antes (v2.0)**:
- Session state: 245 linhas
- Global safe: 165 linhas
- Weekly: 228 linhas
- Daily: 66 linhas
- **Total: ~704 linhas (~8.000 tokens)**

**Depois (v2.1 - Quick Memories)**:

| Cenário | Linhas | Tokens | Economia |
|---------|--------|--------|----------|
| Projeto específico | ~120 | ~1.400 | **84%** |
| Exploração livre | ~90 | ~1.000 | **88%** |

## Gatilhos Temporais

- **Toda sexta-feira**: Alerta para `/aggregate week`
- **Último dia do mês**: Alerta para `/aggregate month`
- **Status visível**: Sem necessidade de ler logs para saber se agregação está pendente

## Notas

- **Lazy loading**: Carregar apenas quando necessário
- **Multi-resolution**: Quick (startup) → Full (se precisar de detalhes)
- **Temporal triggers**: Lembretes automáticos baseados em data
- **Status rápido**: Aggregation status no session-state (sempre visível)
