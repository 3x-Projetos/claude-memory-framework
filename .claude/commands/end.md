---
description: Finaliza sessão e cria/atualiza log de atividades
---

Finalizando sessão com sistema de memória hierárquica.

## Passos

### 1. Perguntar ao usuário
- Qual foi o tópico/foco principal da sessão?
- Quais foram as principais atividades realizadas?
- Há próximos passos ou tarefas pendentes?
- (Opcional) Se `.metrics-reflection.tmp` existir, perguntar se deseja incluir

### 2. Inferir métricas da sessão
Análise automática (baseado em `.workflow-metrics-collection.md`):
- Duration: Inferir da sessão
- Files modified: Contar arquivos tocados
- Commits: Se houver git activity
- Complexity: Baixa/Média/Alta (baseado em linguagem dos logs)
- New tech: Tecnologias novas mencionadas
- AI reliance: Baixa/Média/Alta (baseado em autonomia)

### 3. Criar/atualizar log diário
**Localização**: `logs/daily/YYYY.MM.DD.md`

- Se não existir: criar novo com estrutura de `.workflow-session-logging.md`
- Se existir: adicionar nova seção de sessão

Incluir seção `## Métricas da Sessão` com métricas inferidas e relatadas (se houver)

### 4. Atualizar .session-state.md
Atualizar working memory com:
- Última sessão: Data atual
- Resumo: 1 linha do que foi feito
- Pendências ativas: Lista de TODOs não completados
- Arquivos principais: Top 5-10 arquivos tocados
- Próximos passos: Do que usuário informou

### 5. Detectar necessidade de agregações
- **Weekly**: Se última semana completa não tem resumo em `logs/weekly/`
  - Informar usuário: "Semana X de YYYY sem resumo. Execute `/aggregate week` para agregar."
- **Monthly**: Se último mês completo não tem resumo em `logs/monthly/`
  - Informar usuário: "Mês YYYY.MM sem resumo. Execute `/aggregate month` para agregar."

### 6. Cleanup
**CRÍTICO**: Deletar arquivos de estado da sessão para marcar como registrada:
```bash
rm -f .claude/.current-session-id .claude/.previous-session-id
```

Se `.metrics-reflection.tmp` foi incorporado, deletar também:
```bash
rm -f .metrics-reflection.tmp
```

### 7. Confirmação
Informar ao usuário:
- ✓ Log criado/atualizado em `logs/daily/YYYY.MM.DD.md`
- ✓ .session-state.md atualizado
- (Se aplicável) ⚠️ Agregações pendentes detectadas
- "Sessão finalizada com sucesso. Até a próxima!"
