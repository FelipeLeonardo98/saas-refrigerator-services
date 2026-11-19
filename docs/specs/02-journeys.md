# 02 — Jornadas

## Cliente final (público, sem login)

### J1 — Pedir pré-orçamento
1. Abre o link público do prestador.
2. Escolhe tipo: **instalação** | **manutenção** | **outros**.
3. Descreve o ambiente: área (m²), nº de pessoas, eletrônicos, exposição ao sol, pé-direito, observações.
4. Anexa fotos/vídeo (opcional).
5. Vê uma **estimativa de BTU** na hora (instalação) + disclaimer "não substitui a avaliação do prestador".
6. Informa nome, contato (e-mail/telefone), tipo (PF/PJ).
7. Envia → recebe **nº de protocolo** + mensagem "enviaremos confirmação por e-mail/WhatsApp e o prestador entra em contato em breve" (stub).

### J2 — Acompanhar pré-orçamento
1. Informa **protocolo** ou e-mail/telefone.
2. Vê o status atual (recebido → em análise → orçamento enviado → ...).

## Prestador (painel, login mock)

### J3 — Receber e qualificar lead
1. Novo lead aparece na **home** ("precisam de atenção") e na lista de **Leads**.
2. Abre o detalhe: specs do ambiente + mídia + estimativa de BTU.
3. Contata o cliente (fora do app) e **qualifica** → promove o lead a `Customer`.

### J4 — Montar orçamento com breakdown
1. A partir do lead, cria um **Quote**.
2. Adiciona itens por categoria (equipamento, mão de obra, local, deslocamento).
3. O total soma automaticamente. Ex: Instalação R$ 1.700 = R$ 800 equipamentos + R$ 500 mão de obra + R$ 400 local.
4. Envia (status → enviado). Cliente vê refletido no acompanhamento.

### J5 — Executar e concluir (OS)
1. Orçamento aprovado → vira **ServiceOrder** agendada.
2. Ao concluir: registra o **Equipment** (marca, BTU, data) e **configura o lembrete** (quantos dias antes, canal).
3. Isso agenda um **Reminder** e atualiza o prontuário do cliente.

### J6 — Prontuário / carteira
1. Busca cliente por nome / e-mail / telefone.
2. Vê **histórico completo**: equipamentos, serviços, orçamentos, próximas manutenções.

### J7 — Retenção na home
1. Tela inicial mostra: **atendimentos da semana**, **ganhos do período**, **quem precisa de atenção** (manutenção atrasada / vencendo).

### J8 — Ask to AI (reservado)
Espaço no painel para um assistente que orienta o prestador no atendimento. **Não funcional** na Fase 1 — UI presente, desabilitada, com placeholder.
