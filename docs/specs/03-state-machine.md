# 03 — Máquina de estados (pipeline)

```
Lead(novo) → Qualificado → OrçamentoEnviado → Aprovado  → Agendado → EmExecução → Concluído → [LembreteAgendado] ↺
                                            ↘ Recusado (fim)
```

## Estados do Lead

| Estado | Significado | Gatilho de entrada | Efeitos colaterais |
|---|---|---|---|
| `novo` | Cliente enviou o pré-orçamento | J1 (envio público) | Notifica prestador (home + lista); confirma ao cliente (stub) |
| `qualificado` | Prestador contatou / validou | J3 | Promove snapshot → `Customer` |
| `orcamento_enviado` | Quote enviado ao cliente | J4 | Cliente vê no acompanhamento |
| `aprovado` | Cliente aceitou | manual | Gera `ServiceOrder` agendada |
| `recusado` | Cliente recusou | manual | Fim do fluxo (fica no histórico) |

## Estados da ServiceOrder

| Estado | Significado | Efeitos |
|---|---|---|
| `agendado` | Data marcada | Entra em "atendimentos da semana" |
| `em_execucao` | Em andamento | — |
| `concluido` | Serviço feito | Cria/atualiza `Equipment`; agenda `Reminder` (J5) |

## Estados do Reminder

| Estado | Significado |
|---|---|
| `agendado` | Aguardando `dueAt - leadDays` |
| `enviado` | Disparado (stub); pode reabrir um novo `Lead` |
| `cancelado` | Prestador cancelou |

## Loop de retenção

`ServiceOrder.concluido` → `Equipment.lastMaintenanceAt` definido → próxima manutenção = `lastMaintenanceAt + maintenanceIntervalDays` → `Reminder.dueAt`. Quando o lembrete dispara e o cliente responde, abre-se um novo `Lead` e o ciclo recomeça.

## Derivações para a home (sem tabela nova)

- **Atendimentos da semana** = `ServiceOrder` com `scheduledFor` dentro da semana.
- **Ganhos do período** = soma de `Quote.total` aprovados (ou `ServiceOrder.amount` concluídos) no período.
- **Precisam de atenção** = `Equipment` cujo "próxima manutenção" já passou ou vence em ≤ N dias.
