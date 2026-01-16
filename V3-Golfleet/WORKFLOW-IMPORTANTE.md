# Workflow Importante - Regras Críticas

## 🚨 CRÍTICO: Sempre Matar Servidores em Background

### Problema
Quando Claude testa código, ele inicia servidores em background que continuam rodando mesmo após os testes. Isso causa erro `EADDRINUSE` quando o usuário tenta iniciar os servidores.

### Solução: SEMPRE executar antes de finalizar sessão

```bash
# Matar processos nas portas 3000 e 5173
powershell -Command "Get-Process | Where-Object {$_.Id -in (netstat -ano | Select-String ':3000|:5173' | Select-String 'LISTENING' | ForEach-Object {($_ -split '\s+')[-1]}) } | Stop-Process -Force"
```

**OU** usar o script helper criado:

```bash
cd C:\Users\Luis Romano\videotelemetria-ui
powershell -ExecutionPolicy Bypass -File kill-servers.ps1
```

### Checklist Pré-Finalização

Antes de cada resposta final ao usuário onde você testou código:

- [ ] Verifiquei portas 3000 e 5173?
- [ ] Matei processos em background?
- [ ] Confirmei que portas estão livres?

### Script Helper para Usuário

Criado: `videotelemetria-ui/kill-servers.ps1`

**Uso**:
```powershell
.\kill-servers.ps1
```

Este script automaticamente:
1. Encontra processos nas portas 3000 e 5173
2. Mata os processos
3. Confirma que portas estão livres

---

## 📋 Outros Workflows Importantes

### Antes de Implementar Features

1. **Consultar TEAMS-FRAMEWORK.md** para escolher team pattern
2. **Verificar agents disponíveis** em `.claude/agents/`
3. **Criar novos agents** se necessário antes de trabalhar

### Ao Debugar APIs

1. **Usar api-debugger agent** para comparar Postman + scripts + código
2. **NUNCA** assumir formatos de endpoint sem validar
3. **SEMPRE** comparar com implementações funcionais (Python scripts)

### Ao Modificar UI/UX

1. **Usar ui-specialist** para layout
2. **Usar ux-specialist** para fluxos de usuário
3. **Validar em paralelo** quando possível

---

**Última atualização**: 2026-01-16
**Autor**: Luis Romano + Claude Sonnet 4.5
