# Adendos ao Projeto - Videotelemetria UI

## Sprint 3: Command Sending

### Adendo 1: Botão de Requisição de MAC Address

**Data**: 2026-01-16
**Solicitante**: Luis Romano
**Prioridade**: Média

**Descrição**:
Adicionar botão de ação rápida para requisitar MAC address do device.

**Comando**:
O comando foi compartilhado anteriormente e deve estar disponível no catálogo de comandos.

**Localização**:
- Frontend: `frontend/src/components/QuickCommands.tsx`
- Adicionar junto com Reboot, Volume, List Directory

**Implementação necessária**:
1. Adicionar botão "Get MAC Address" em QuickCommands
2. Configurar payload do comando conforme catálogo
3. Testar envio e resposta

**Status**: PENDENTE (aguardando implementação)

---

## Histórico de Mudanças

### 2026-01-16: Correções Críticas API
- Endpoint corrigido: `/order/devices/{imei}/config`
- Authorization header corrigido: `Bearer {token}`
- Parameter casing implementado: UPPERCASE para COMMAND, lowercase para CONFIG
- Agente usado: api-debugger (novo)
- Status: ✅ IMPLEMENTADO (aguardando teste do usuário)

### 2026-01-16: UI/UX Improvements
- Layout otimizado (AppLayout compactado)
- Scroll vertical eliminado
- Sticky table header implementado
- ULID completo visível
- Agentes usados: ui-specialist, ux-specialist (novos)
- Status: ✅ IMPLEMENTADO

### 2026-01-16: Auto-Refresh Token
- Implementado sistema de auto-refresh usando credenciais encriptadas
- AES-256-GCM encryption para clientSecret
- Schema alterado (Token model com clientId e encryptedSecret)
- Status: ✅ IMPLEMENTADO

---

## Próximas Features Planejadas

### Sprint 4: Respostas e Comandos Multi-Step
- Parser de respostas via Events API
- Comandos multi-step (tar → upload)
- Response viewer component

### Sprint 5: Multi-Device Operations
- Bulk command sending
- Progress tracking para múltiplos devices
- Retry logic

### Sprint 6: Mídia e Arquivos
- Request de imagens/vídeos
- Download de arquivos do device
- Media request form

---

## Notas Técnicas

### Comandos Disponíveis (Catálogo)
Localização: `shared/commands.ts`

Confirmados funcionando:
- ✅ REBOOT
- ✅ VOLUME (CONFIG type)
- ✅ LS_DRIVERCOACH

Pendentes de teste:
- 🔄 GET_MAC_ADDRESS (adendo 1)
- 🔄 Demais comandos do catálogo

### Endpoints Confirmados
- ✅ POST `/order/devices/{imei}/config` - enviar comandos
- ✅ GET `/order/devices/details/{imei}` - buscar orders
- ✅ DELETE `/order/devices/{imei}` - deletar all orders
- ✅ DELETE `/order/{ulid}` - deletar single order
- ✅ GET `/history` - command history
- ⏳ GET `/events/search` - buscar eventos (Sprint 4)

---

**Última atualização**: 2026-01-16 15:15 BRT
