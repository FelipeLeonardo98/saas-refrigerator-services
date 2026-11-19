# 00 — Visão geral

## Ideia central

Um **pipeline único** que vai de *lead* até *relacionamento recorrente*. Cada funcionalidade é uma etapa desse funil:

- **Avaliação de orçamento** = captação de lead (topo de funil).
- **Cálculo de BTU + breakdown do orçamento** = ferramenta de conversão (dá clareza, justifica preço).
- **Ordem de serviço (OS)** = execução.
- **Lembrete de manutenção** = loop de retenção. Em ar-condicionado, a manutenção recorrente é o que vira LTV. O lembrete re-alimenta o topo do funil sozinho — é o principal diferencial frente a um CRM genérico.

Ou seja: não é "um formulário + uma agenda". É um **funil com memória**, onde o que foi instalado hoje gera o próximo serviço daqui a X meses.

## Atores

| Ator | Papel | Fase |
|---|---|---|
| **Prestador** | O *tenant*. Dono da carteira. Hoje um só (EcoTherm). | 1 |
| **Cliente final** | PF ou PJ. Pede orçamento, recebe serviço, recebe lembrete. Sem login. | 1 |
| **Operador da plataforma** | Dono do SaaS (admin multi-tenant). | Futuro |

## Escopo do PoC (Fase 1)

**Lado cliente (público, sem login):**
- Pré-orçamento: tipo de serviço (instalação / manutenção / outros), specs do ambiente, upload de fotos/vídeo (mock), estimativa de BTU na hora (com disclaimer).
- Confirmação com nº de protocolo + aviso de notificação (stub).
- Acompanhar pré-orçamento por protocolo ou e-mail/telefone.

**Lado prestador (painel, login mock):**
- Home: atendimentos da semana, ganhos, quem precisa de atenção (manutenção atrasada).
- Leads: tabela de oportunidades + detalhe (specs + mídia).
- Orçamento: breakdown em itens (equipamento / mão de obra / local) → total.
- Carteira / prontuário do cliente: histórico completo de serviços e equipamentos.
- Config de lembrete ao concluir OS.
- Espaço "Ask to AI" (reservado, não funcional).

## Fora de escopo (Fase 1)

- Envio real de e-mail/WhatsApp.
- Multi-tenant na UI.
- Pagamentos.
- Assistente de IA funcional.
- Banco compartilhado / fluxo cross-device real.

## Princípios de arquitetura

- **Mínimo de escala, fácil adaptação:** modelo já carrega `tenantId`; trocar persistência (localStorage → Postgres) não deve mexer na forma dos dados.
- **Asset-centric ("prontuário"):** o cliente tem *equipamentos* rastreados; serviços penduram no equipamento. É o que torna "quem está atrasado" uma query trivial.
- **Mídia por referência:** nunca binário no banco; guarda-se a URL. No PoC, data URL.
