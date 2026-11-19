# SAVEPOINTS (AI-DLC)

Log append-only de onde paramos e para onde vamos. Entrada mais recente no fim.

---

## Savepoint 001 — 2026-11-18 — Fundação SDD + PoC Fase 1

**Contexto**
PoC navegável do EcoTherm CRM. Prestador único (white-label EcoTherm, Praia Grande/SP). Objetivo: validar jornadas com um prestador real, sem custo e sem cadastro.

**Decisões**
- Fase 1 = HTML único (React/Tailwind via CDN) + `localStorage`, publicado como artifact → link público. Sem backend, sem conta.
- Modelo asset-centric ("prontuário do cliente"): equipamentos rastreados, serviços pendurados neles.
- Multi-tenant por linha (`tenantId` em tudo), mas UI de um tenant só.
- Storage Fase 2: Supabase (Postgres + Storage). Trocar provider do Prisma é mecânico.
- Notificações e "Ask to AI": apenas stub/placeholder na Fase 1.
- Regra de BTU genérica parametrizável (ver `04-btu-rule.md`), com disclaimer.

**Feito nesta sessão**
- `AGENTS.md`, `README.md`.
- `docs/specs/` (overview, domínio, jornadas, máquina de estados, BTU).
- `prisma/schema.prisma` (modelo completo como spec).
- `web/index.html` (PoC rodável: lado cliente + painel do prestador, seed + persistência).

**Estado atual**
PoC funcional client-side. Publicado como artifact.

**Próximos passos**
- Coletar feedback do prestador sobre as jornadas.
- Liberar push no repo (instalar Claude GitHub App).
- Fase 2: scaffold Next.js + Prisma + Supabase; ligar e-mail (Resend).
- Prestador define a própria fórmula de BTU.
- Avaliar esforço do multi-tenant real.

**Decisões em aberto**
- Canal de notificação definitivo (e-mail só? WhatsApp via Meta/Z-API?).
- Modelo de cobrança do SaaS (quando sair do PoC).
