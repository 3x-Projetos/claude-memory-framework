# Notas Técnicas: Comandos e Respostas

## 🎯 Informações Críticas sobre Respostas de Comandos

### Tipos de Comandos e Suas Respostas

#### 1. Comandos Shell (Android direto)

**Características**:
- `type: "COMMAND"`
- `Module: "cmdd"`
- `Key: "shellCmd"` ou `"shellScript"`
- Executam diretamente no sistema Android

**Como obter resposta**:
1. Resposta retorna dentro de **payload de evento**
2. Não aparece diretamente no order
3. Precisa buscar usando **GET events from device by time**
4. Buscar pelo momento em que `updatedAt` mudou para status `PROCESSED`

**Exemplo - MAC Address**:
```json
{
    "type": "COMMAND",
    "parameters": [
        {
            "Module": "cmdd",
            "Key": "shellCmd",
            "Value": "cat /sys/class/net/wlan0/address",
            "Type": "string"
        }
    ]
}
```

**Resposta esperada**:
- Localização: Events API → payload do evento com `originalUlid` = orderUlid
- Formato: String com MAC address (ex: "aa:bb:cc:dd:ee:ff")
- Timing: Quando order.status = PROCESSED

**Outros exemplos de comandos shell**:
- `ls /mnt/sdcard/driverCoach` → Lista de arquivos
- `cat /proc/meminfo` → Info de memória
- Qualquer comando Linux padrão

---

#### 2. Comandos Multi-Step (Arquivo + Upload)

**Características**:
- Dois comandos sequenciais
- Primeiro: Cria arquivo no diretório uploader
- Segundo: Upload para bucket na cloud

**Workflow**:
```
Step 1: tar -czf /uploader/databases.tar.gz /data/databases/
        → Order ULID 1
        → Status: PENDING → PROCESSING → COMPLETED

Step 2: upload /uploader/databases.tar.gz to S3
        → Order ULID 2
        → Status: PENDING → PROCESSING → COMPLETED
        → Resposta: URL do arquivo no S3
```

**Exemplos conhecidos**:
- UPLOAD_DATABASES: tar databases → upload
- UPLOAD_SHARED_PREFS: tar shared_prefs → upload
- UPLOAD_TELEPHONY_DB: tar telephony.db → upload

**Como obter arquivo**:
- Resposta do Step 2 contém URL do bucket
- Download direto do S3 (pode precisar de proxy para CORS)

---

## 📋 Catálogo de Comandos por Tipo

### Shell Commands (Resposta via Events)

| Comando | Key | Value | Resposta Esperada |
|---------|-----|-------|-------------------|
| Get MAC | shellCmd | `cat /sys/class/net/wlan0/address` | MAC address string |
| List Dir | shellScript | `ls /mnt/sdcard/driverCoach` | Lista de arquivos |
| Reboot | shellCmd | `reboot` | Nenhuma (device reinicia) |
| Memory Info | shellCmd | `cat /proc/meminfo` | Info de memória |
| Disk Usage | shellCmd | `df -h` | Uso de disco |

### Config Commands (Resposta imediata no order)

| Comando | module | key | Resposta Esperada |
|---------|--------|-----|-------------------|
| Set Volume | voiced | MEDIA_VOLUME | Order status = COMPLETED |
| Set Brightness | voiced | BRIGHTNESS | Order status = COMPLETED |

### Multi-Step Commands (Arquivo no S3)

| Comando | Steps | Resposta Esperada |
|---------|-------|-------------------|
| Upload Databases | tar → upload | S3 URL |
| Upload Shared Prefs | tar → upload | S3 URL |
| Upload Telephony DB | tar → upload | S3 URL |

---

## 🔍 Sprint 4: Events API Integration

### Endpoint GET events

**Path**: `/events/search` ou similar
**Method**: GET
**Params**:
- `imei`: Device IMEI
- `startTime`: Unix timestamp (ms)
- `endTime`: Unix timestamp (ms)
- `orderUlid`: (opcional) filtrar por order específico

**Response**:
```json
{
  "events": [
    {
      "timestamp": 1737057600000,
      "originalUlid": "01KE1Z4GX5...",  // Matches orderUlid
      "payload": {
        // Resposta do comando aqui
        "stdout": "aa:bb:cc:dd:ee:ff",  // Para shell commands
        // ou
        "files": ["databases.tar.gz"],   // Para multi-step
        // ou
        "error": "Command failed"        // Se deu erro
      }
    }
  ]
}
```

### Lógica de Busca de Resposta

```typescript
async function getCommandResponse(orderUlid: string, order: Order) {
  // 1. Pegar timestamp do updatedAt quando status = PROCESSED
  const endTime = order.updatedAt  // Unix ms
  const startTime = endTime - (5 * 60 * 1000)  // 5 minutos antes

  // 2. Buscar eventos no range
  const events = await api.get('/events/search', {
    params: { imei: order.imei, startTime, endTime }
  })

  // 3. Filtrar evento com originalUlid = orderUlid
  const responseEvent = events.find(e => e.originalUlid === orderUlid)

  // 4. Extrair resposta do payload
  if (responseEvent) {
    return responseEvent.payload.stdout || responseEvent.payload
  }

  return null  // Sem resposta ainda
}
```

---

## 🎯 Implicações para UI/UX

### Command History Table

**Adicionar coluna "Response"**:
- Shell commands: Botão "Get Response" (busca via Events API)
- Multi-step: Botão "Download File" (link para S3)
- Config commands: Status apenas (sem resposta adicional)

### Response Viewer Component

**Funcionalidades**:
- Busca automática quando order.status = PROCESSED
- Exibe stdout formatado
- Suporta copy to clipboard
- Mostra erro se comando falhou
- Loading state enquanto busca

### Multi-Step Progress

**Estados possíveis**:
- Step 1: Creating TAR... ✅ COMPLETED
- Step 2: Uploading to S3... ⏳ PROCESSING
- Download: [Download File Button]

---

## 📝 TODOs para Sprint 4

### Backend
- [ ] Implementar GET `/api/events/search`
- [ ] Proxy para S3 (evitar CORS)
- [ ] Parser de eventos (extrair stdout, files, errors)
- [ ] Multi-step orchestrator (tar → upload sequencial)

### Frontend
- [ ] ResponseViewer component
- [ ] Botão "Get Response" em CommandHistory
- [ ] Multi-step progress indicator
- [ ] File download handler

### Validação
- [ ] api-debugger: Validar Events API formato
- [ ] backend-validator: Validar parser logic
- [ ] frontend-validator: Validar UX de responses
- [ ] ux-specialist: Validar fluxo de ver resposta

---

## 🔗 Referências

- Postman Collection: `C:\Users\Luis Romano\.claude\V3-Golfleet\V3Pro.postman_collection.json`
- Python Script: `C:\Users\Luis Romano\.claude\V3-Golfleet\Batch-InternalOrder_v3.2-payload+imei.py`
- Shared Commands: `shared/commands.ts`

---

**Última atualização**: 2026-01-16
**Autor**: Luis Romano + Claude Sonnet 4.5
