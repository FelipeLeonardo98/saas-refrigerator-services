# 01 — Modelo de domínio

Todas as entidades carregam `tenantId` (multi-tenant por linha).

## Entidades

### Tenant (Prestador)
A empresa prestadora. Fase 1: um só (EcoTherm).
`id, name, slug, tagline, logoUrl, brandColors, city, region, createdAt`

### Customer (Cliente final)
PF ou PJ.
`id, tenantId, type (PF|PJ), name, document (CPF|CNPJ), email, phone, createdAt`
- PJ com mais de uma unidade → distinguir por `Site.name` / `Site.address` (simples).

### Site (Local / Unidade)
Endereço onde ficam os equipamentos. PF normalmente tem 1; PJ pode ter vários.
`id, tenantId, customerId, name, address, notes`

### Equipment (Equipamento / Ativo) — o "prontuário"
Cada aparelho rastreado do cliente.
`id, tenantId, customerId, siteId, brand, model, btu, type (split|janela|cassete|multi|outro), installedAt, warrantyUntil, lastMaintenanceAt, maintenanceIntervalDays, status (ativo|inativo)`
- `maintenanceIntervalDays` menor no litoral (maresia). Default sugerido: 180; litoral: 90–120.
- `lastMaintenanceAt + maintenanceIntervalDays` → data da próxima manutenção. Base do motor de lembrete.

### Lead (Oportunidade / Pré-orçamento)
O pedido que o cliente envia pela tela pública.
`id, tenantId, protocol, customerSnapshot {name,email,phone,type}, serviceType (instalacao|manutencao|outros), environment {areaM2, people, electronics, sunExposure, ceilingHeight, notes}, media [urls], estimatedBtu, status, createdAt`
- `customerSnapshot`: no envio o cliente pode ainda não existir como `Customer`. O prestador promove o lead a `Customer` ao qualificar.
- `protocol`: código curto que o cliente anota para acompanhar (ex: `ECO-7F3K`).

### Quote (Orçamento)
Resposta do prestador a um lead.
`id, tenantId, leadId, customerId, status (rascunho|enviado|aprovado|recusado), items [QuoteLineItem], total, validUntil, createdAt`

### QuoteLineItem (Item do breakdown)
`id, quoteId, category (equipamento|material|mao_de_obra|local|deslocamento|outro), description, amount`
- `total` = soma dos `amount`.

### ServiceOrder (Ordem de serviço / OS)
Execução de um serviço aprovado.
`id, tenantId, customerId, quoteId, equipmentId?, serviceType, status, scheduledFor, completedAt, amount, notes, reminderConfig {enabled, leadDays, channel}`
- Ao concluir: cria/atualiza `Equipment` e agenda `Reminder`.

### Reminder (Lembrete)
Disparo futuro de retenção.
`id, tenantId, customerId, equipmentId, dueAt, leadDays, channel (email|whatsapp|ambos), status (agendado|enviado|cancelado)`
- Ao vencer, pode reabrir um novo `Lead` (fecha o ciclo).

### Media
`id, tenantId, ownerType (lead|serviceOrder), ownerId, kind (foto|video), url`

## Relações (resumo)

```
Tenant 1─* Customer 1─* Site 1─* Equipment
Customer 1─* Lead 1─1 Quote 1─* QuoteLineItem
Quote 1─1 ServiceOrder *─1 Equipment
ServiceOrder 1─* Reminder
(Lead|ServiceOrder) 1─* Media
```

## Observação de modelagem

As specs de ambiente do `Lead` (área, pessoas, eletrônicos, sol) são **pré-dados do `Equipment`**. Ao concluir a OS, elas viram um ativo rastreado. Modelar assim desde já é o que torna a carteira e o lembrete baratos.
