# EcoTherm CRM

CRM / gestão de serviços para prestadores de **instalação e manutenção de ar-condicionado**. SaaS B2B2C — construído para um prestador (EcoTherm) rodar como piloto, com arquitetura pensada para multi-tenant.

## Status

**Fase 1 — PoC navegável.** Roda 100% no navegador, com dados semeados e persistência em `localStorage`. Sem backend, sem cadastro, sem custo. Serve para validar as jornadas com um prestador real.

## Como rodar

Abra `web/index.html` no navegador. Não precisa de build nem servidor.

- **Lado cliente:** tela pública de pré-orçamento (link que o prestador divulga).
- **Lado prestador:** painel de gestão (login mock).
- **Resetar dados:** botão no rodapé do painel.

## Link público (qualquer um acessa)

- **GitHub Pages (recomendado, seu domínio):** já há um workflow em `.github/workflows/deploy-pages.yml`. Após o push, vá em **Settings → Pages → Source: "GitHub Actions"**. Publica a pasta `web/` em `https://felipeleonardo98.github.io/saas-refrigerator-services/`.
- **Instantâneo, sem repo:** arraste `web/index.html` em https://app.netlify.com/drop → link público na hora.

## Documentação (Spec-Driven Development)

A fonte da verdade está em [`docs/specs/`](docs/specs/). Comece por [`AGENTS.md`](AGENTS.md).

- [`00-overview`](docs/specs/00-overview.md) — ideia, atores, escopo
- [`01-domain-model`](docs/specs/01-domain-model.md) — entidades e relações
- [`02-journeys`](docs/specs/02-journeys.md) — jornadas
- [`03-state-machine`](docs/specs/03-state-machine.md) — pipeline
- [`04-btu-rule`](docs/specs/04-btu-rule.md) — cálculo de BTU
- [`prisma/schema.prisma`](prisma/schema.prisma) — modelo de dados (alvo Fase 2)
- [`docs/SAVEPOINTS.md`](docs/SAVEPOINTS.md) — log de progresso (AI-DLC)

## Roadmap

- **Fase 2:** Next.js + Prisma + Supabase (Postgres + Storage). Fluxo cross-device real, e-mail (Resend).
- **Fase 3:** WhatsApp, assistente "Ask to AI" funcional, multi-tenant na UI, cobrança.
