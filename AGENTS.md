# AGENTS.md — EcoTherm CRM (SaaS B2B2C para climatização)

> Orientação curta para agentes de IA. Leia **este arquivo + `docs/specs/`** antes de codar.
> Não precisa ler o repo inteiro. O que você precisa saber está aqui.

## O que é

CRM / gestão de serviços para prestadores de **instalação e manutenção de ar-condicionado**.
Modelo de negócio: **B2B2C**. O cliente do produto é o **prestador**; o cliente do prestador é o **consumidor final** (PF ou PJ).

- **Fase atual:** PoC navegável, 1 prestador (white-label: **EcoTherm**), dados semeados, persistência no navegador. Sem backend, sem cadastro, sem custo.
- **Objetivo do PoC:** validar as jornadas e o valor com um prestador real, coletar feedback, estimar esforço. Nada é definitivo.
- **Multi-tenant** é intenção de arquitetura, não realidade ainda: o modelo de dados já carrega `tenantId`, mas a UI só mostra um tenant.

## Stack

| Camada | Fase 1 (agora) | Fase 2 (quando houver banco) |
|---|---|---|
| UI | HTML único + React 18 (CDN) + Tailwind (CDN) | Next.js 15 (App Router) + TS + Tailwind + shadcn/ui |
| Dados | `localStorage` (semeado no 1º load) | Postgres (Supabase) via Prisma |
| Mídia | data URLs no navegador | Supabase Storage (URL no banco) |
| Validação | checagem manual leve | Zod (schema compartilhado) |
| Notificação | stub visual (toast "e-mail enviado") | Resend (e-mail) → WhatsApp (fase 3) |
| Deploy | Artifact (link público) | Vercel + Supabase |

**Por que HTML único na Fase 1:** dá link público instantâneo, sem conta e sem custo. O `prisma/schema.prisma` já é a spec do modelo real, então migrar para Next.js/Prisma é mecânico.

## Onde cada coisa vive

```
AGENTS.md                 ← você está aqui
README.md                 ← visão humana + como rodar
docs/
  specs/                  ← fonte da verdade (SDD): leia antes de codar
    00-overview.md        ← ideia, atores, escopo
    01-domain-model.md    ← entidades e relações
    02-journeys.md        ← jornadas cliente + prestador
    03-state-machine.md   ← pipeline lead → ... → lembrete
    04-btu-rule.md        ← regra de carga térmica (BTU)
  SAVEPOINTS.md           ← AI-DLC: log de onde paramos / próximos passos
prisma/
  schema.prisma           ← modelo de dados executável (alvo da Fase 2)
web/
  index.html              ← o PoC rodável (Fase 1)
```

## Convenções

- **SDD:** mudou o comportamento? Atualize a spec em `docs/specs/` **antes/junto** do código.
- **AI-DLC:** terminou uma sessão de trabalho? Acrescente um bloco em `docs/SAVEPOINTS.md` (append-only).
- **Idioma:** produto, specs e UI em **pt-BR**. Código em inglês (nomes de entidade/campo).
- **Marca:** EcoTherm. Verde `#5BC236`, azuis `#4FC3F7 → #29ABE2 → #1C75BC`. Tagline: "Soluções Inteligentes em Climatização e Eficiência Energética".
- **Região dos mocks:** Praia Grande / litoral sul SP. Maresia encurta intervalo de manutenção — reflita isso nos dados semeados.

## Como rodar (Fase 1)

Abra `web/index.html` no navegador. Tudo client-side. Para resetar os dados: botão "Resetar dados" no rodapé do painel, ou limpe o `localStorage` da página.

## O que NÃO fazer ainda

- Não ligar e-mail/WhatsApp de verdade (stub visual só).
- Não implementar o "Ask to AI" (espaço reservado, desabilitado).
- Não assumir que `localStorage` compartilha entre dispositivos — não compartilha. O fluxo cross-device (cliente no celular → prestador no desktop) só existe de verdade na Fase 2.
