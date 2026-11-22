# Banco de dados (Supabase) — Fase 2

Objetivo: trocar o `localStorage` por um **banco compartilhado**, para ter persistência real e coerência entre leads, orçamentos e serviços (e o fluxo cross-device: cliente envia no celular → prestador vê no painel).

## Abordagem (recomendada)

Manter o front atual (estático, no GitHub Pages) e falar **direto com o Supabase** pelo cliente JS (`@supabase/supabase-js`), protegido por RLS. Sem servidor novo, sem Vercel, sem custo. O Next.js fica para quando a lógica/segurança exigir (Fase 3).

## Passos

1. Crie um projeto em https://supabase.com (free tier).
2. No **SQL Editor**, cole e rode o `schema.sql` deste diretório. Cria as tabelas, o tenant EcoTherm e as políticas de RLS do piloto.
3. Em **Project Settings → API**, copie:
   - **Project URL** (ex: `https://xxxx.supabase.co`) — público.
   - **anon public key** — público (feito para o front-end, protegido por RLS).
4. Me passe **somente** a Project URL e a **anon key**. Elas são públicas (podem ir pro repo).
   - **NÃO** compartilhe a `service_role` key nem a senha do banco — essas são secretas.
5. Eu ligo o front nessas credenciais e migro a camada de dados do `localStorage` para o Supabase.

## Segurança (importante)

As políticas de RLS no `schema.sql` são **permissivas** (qualquer um com a anon key lê/grava) — ok para um piloto de 1 prestador. Antes de multi-tenant / produção, trocar por políticas com `auth.uid()` e login do prestador (Supabase Auth). Está anotado no próprio SQL.

## Mídia (fotos/vídeos)

Criar um bucket no **Storage** (ex: `media`) e guardar só a URL na tabela `media`. Fica para o passo de ligar o front.
