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

---

## Savepoint 002 — 2026-11-18 — Deploy público + fix tela branca

**Feito**
- Push liberado (Claude GitHub App instalado). `main` no GitHub.
- GitHub Pages ligado (Source: GitHub Actions). PoC público em
  https://felipeleonardo98.github.io/saas-refrigerator-services/
- Fix tela branca: `@babel/standalone` usava "automatic runtime" (injeta
  `import` de react/jsx-runtime → quebra em script inline). Agora o JSX é
  transformado manualmente com `{ runtime: 'classic' }`.
- Verificado no navegador: render OK, console sem erros, dashboard com dados.

**Estado atual**
PoC Fase 1 no ar e funcional no link público.

**Próximos passos**
- Feedback do prestador.
- Fase 2: Next.js + Prisma + Supabase (fluxo cross-device real, e-mail).

---

## Savepoint 003 — 2026-11-22 — Feedbacks do piloto + início do banco

**Feito (feedbacks)**
- Mobile: sidebar do prestador virou drawer com botão hambúrguer + overlay;
  cabeçalho do cliente e linhas do orçamento responsivos.
- Envio do orçamento real (sem backend): gera a mensagem com o breakdown e
  abre WhatsApp (wa.me) ou e-mail (mailto) já preenchido p/ o contato do cliente.
- Categoria "Material / Insumos" adicionada ao orçamento.

**Feito (banco — início)**
- `supabase/schema.sql`: DDL Postgres espelhando o modelo + tenant EcoTherm + RLS de piloto (permissiva).
- `supabase/README.md`: abordagem (front estático + supabase-js, mantém Pages, sem custo) e passo a passo.

**Pendente de você**
- Criar projeto no Supabase, rodar o `schema.sql`, e me passar Project URL + anon key
  (públicas). NÃO compartilhar service_role key nem senha do banco.

**Próximos passos (meus, após as credenciais)**
- Ligar o front ao Supabase (migrar camada localStorage -> supabase-js).
- Bucket de Storage p/ mídia.
- Seed inicial no banco (opcional).
