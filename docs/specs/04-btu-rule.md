# 04 — Regra de carga térmica (BTU)

> **Disclaimer obrigatório na UI:** a estimativa é uma referência automática e **não substitui** a avaliação técnica do prestador.

## Objetivo

Dar ao cliente, no envio do pré-orçamento de **instalação**, um número de BTU/h plausível a partir das specs do ambiente. O prestador pode depois configurar sua própria fórmula (Fase 2). Na Fase 1 usamos uma regra genérica parametrizável.

## Fórmula genérica (Fase 1)

Regra de bolso comum no Brasil:

```
base      = area_m2 * btu_por_m2            (default 600 BTU/m²)
pessoas   = max(0, people - 2) * 600        (acima de 2 pessoas, +600 por pessoa)
aparelhos = electronics * 600               (cada eletrônico que gera calor: +600)
sol       = sunExposure === 'tarde' ? area_m2 * 200 : 0   (ambiente quente/sol da tarde)

total_bruto = base + pessoas + aparelhos + sol
btu = arredonda_para_capacidade_comercial(total_bruto)
```

### Capacidades comerciais (teto para o próximo tamanho)
`7000, 9000, 12000, 18000, 22000, 24000, 30000, 36000, 48000, 60000`
Arredonda o `total_bruto` para a **menor capacidade comercial ≥ total_bruto** (se exceder 60000, sugere "múltiplas unidades / avaliação técnica").

## Parâmetros (ajustáveis por tenant na Fase 2)

| Parâmetro | Default | Observação |
|---|---|---|
| `btuPorM2` | 600 | 550–800 conforme região/insolação |
| `btuPorPessoaExtra` | 600 | acima de 2 ocupantes |
| `btuPorEletronico` | 600 | TV, PC, forno etc. |
| `fatorSolTarde` | 200 /m² | exposição solar à tarde |
| `capacidades` | lista acima | catálogo comercial |

## Exemplo

Sala 20 m², 4 pessoas, 2 eletrônicos, sol da tarde:
```
base      = 20 * 600 = 12000
pessoas   = (4-2) * 600 = 1200
aparelhos = 2 * 600 = 1200
sol       = 20 * 200 = 4000
bruto     = 18400  → capacidade comercial ≥ 18400 = 22000 BTU/h
```

Para **manutenção** e **outros**, não há cálculo de BTU — o fluxo pula a estimativa.
