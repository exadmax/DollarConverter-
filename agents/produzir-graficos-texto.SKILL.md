---
name: produzir-graficos-texto
user-invocable: true
description: "SKILL — Gera ou orienta a produção de gráficos em modo texto (ASCII/Unicode) para terminais, relatórios e logs. Use quando quiser visualizar séries temporais, barras, histogramas, ou pequenas visualizações sem interface gráfica."
---

# Produção de Gráficos em Modo Texto

Resumo
- Esta skill orienta e automatiza a produção de gráficos em modo texto (ASCII/Unicode), incluindo linhas de tempo, barras, histogramas e pequenos sparklines.
- Foco em terminais sem suporte gráfico, relatórios plain-text e ambientes headless.

Quando usar
- Visualizar séries temporais (cotações, métricas) no terminal.
- Gerar diagramas simples para logs, emails ou arquivos TXT.
- Criar saídas compatíveis com `asciichartpy`, `termplotlib` ou implementações internas.

O que a skill faz (passo-a-passo)
1. Identifica o tipo de dado (série temporal, categoria/contagem, distribuição).
2. Sugere o tipo de gráfico mais adequado (linha, barra, histograma, sparkline).
3. Normaliza e sanitiza os dados (trata NaN, outliers, tamanho da amostra).
4. Calcula escala/intervalos considerando largura/altura do terminal ou parâmetro `width`/`height` passado pelo usuário.
5. Gera o gráfico em texto usando uma das bibliotecas suportadas ou uma rotina interna, com opções de estilo (unicode/ASCII, cores ANSI opcional).
6. Produz versão resumida para logs (uma ou duas linhas) e versão detalhada (múltiplas linhas, eixos e legendas).

Opções e parâmetros aceitos
- `type`: `line` | `bar` | `hist` | `sparkline` (opcional — skill pode inferir)
- `width`: largura em caracteres (padrão: detecta `COLUMNS` do terminal ou 80)
- `height`: altura em linhas (padrão: depende do tipo; ex.: 10 para `line`)
- `style`: `unicode` | `ascii` (padrão `unicode` se suportado)
- `color`: `true` | `false` (usa cores ANSI quando disponível)
- `library`: `asciichartpy` | `termplotlib` | `internal` (pref. `asciichartpy`)
- `compact`: `true` | `false` (se true, gera resumo em 1-2 linhas)

Pontos de decisão (branching)
- Se os dados tiverem > 200 pontos e `compact=true` → gerar sparkline resumido.
- Se terminal não suporta ANSI (fallback detectado) e `color=true` → ignorar cores e avisar.
- Se valores negativos estiverem presentes e `type=bar` → escolher representação com eixo zero central.

Critérios de qualidade / checagem
- O gráfico cabe na largura definida sem cortar números essenciais.
- Eixos ou legenda explicam unidades quando aplicável (%, BRL, USD).
- Para séries temporais, último ponto e variação percentual devem estar destacados (quando `compact=false`).
- Quando a geração depende de uma biblioteca externa, a skill sugere instalação (`pip install asciichartpy`) se faltar.

Exemplos de uso (prompts)
- "Gerar gráfico de linha para esta série de preços, width=60, height=10, library=asciichartpy, color=true"
- "Mostrar sparkline compacto para [0.1,0.2,0.15,0.5,0.4], compact=true"
- "Histograma da distribuição de retornos com 20 bins, style=ascii"

Exemplo de saída (linha simples com asciichartpy):

    0.15 ┤            ╭─╮
    0.10 ┤      ╭╮   │ │
    0.05 ┤ ╭╮   ││╭╮ │ │
    0.00 ┼─┴┴───┴┴┴┴─┴─
         1    5    10  (índice)

Exemplo de sparkline compacto (1 linha):

    ▂▃▂▁▅▇▆▃▁▂

Implementação recomendada
- Preferir `asciichartpy` para séries temporais simples.
- Para barras e histogramas, `termplotlib` ou implementação interna é aceitável.
- Implementar detecção de `COLUMNS` e `LINES` pelo `os.get_terminal_size()` e permitir parâmetros manuais.
- Fornecer fallback sem dependências externas (rotina interna simples) quando `library=internal`.

Perguntas abertas / pontos a clarificar
- Quais bibliotecas você prefere adicionar como dependência (ex.: `asciichartpy`)?
- Deseja suporte a cores ANSI por padrão em terminais que suportam, ou preferir sem cor?
- Padrões de largura/altura preferidos para relatórios vs. terminal interativo?

Sugestões para próximos passos
- Criar uma função utilitária em `core.py` que receba (dados, tipo, width, height, style) e retorne string do gráfico.
- Adicionar testes automatizados que validem o comportamento com entradas pequenas e grandes.

Exemplos de prompts recomendados ao usar a skill
- "Usa esta skill para gerar um gráfico de linha com `width=70` e cores ANSI: [serie]"
- "Gere um sparkline compacto para esses 50 pontos e insira no relatório de email"

---
