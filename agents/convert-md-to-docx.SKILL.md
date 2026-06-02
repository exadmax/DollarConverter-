---
name: convert-md-to-docx
user-invocable: true
description: "SKILL — Guia e workflow para converter arquivos Markdown (.md) em .docx usando bibliotecas Python (pypandoc, python-docx) com opções de fallback e tratamento de imagens/tabelas/código."
---

# Conversão de .md para .docx (Skill)

Resumo
- Esta skill descreve um fluxo reutilizável para converter arquivos Markdown em documentos Microsoft Word (.docx) em projetos Python.
- Apresenta opções com dependências (`pypandoc` + `pandoc`) e implementações puras em Python (`markdown` + `python-docx`) como fallback.

Quando usar
- Quando precisar gerar relatórios Word a partir de conteúdo em Markdown.
- Integração com pipelines de exportação, geração de releases, ou preparação de documentos para usuários finais que precisam de .docx.

Passo-a-passo recomendado
1. Detectar arquivos `.md` a converter (uma ou várias entradas).  
2. Determinar requisitos do documento de saída: estilos, mapeamento de títulos, inclusão de imagens, tabelas, código com destaque de sintaxe, metadados (autor, data).  
3. Preferir `pypandoc` (invoca `pandoc`) quando o ambiente permitir instalação do binário `pandoc` — produz conversões completas e mantém formatações complexas.  
4. Se `pandoc` não estiver disponível, usar uma rota em Python puro: parsear Markdown (ex.: `markdown` ou `mistune`) e gerar `.docx` com `python-docx`, mapeando blocos (headings, paragraphs, lists, code, images, tables).  
5. Tratar imagens: garantir que caminhos sejam relativos locais ou baixar imagens remotas antes da inserção no `.docx`.  
6. Validar saída: abrir/verificar integridade (tamanho, presença de imagens, tabelas), e executar testes simples (ex.: busca por trechos esperados).  
7. Entregar o arquivo `.docx` e/ou retornar caminho/bytes para integração.

Parâmetros e opções da skill
- `input`: caminho para arquivo `.md` ou lista de caminhos.  
- `output`: caminho para `.docx` (opcional; padrão: substitui extensão `.md` → `.docx`).  
- `library`: `pypandoc` | `python-docx` | `auto` (default `auto`: tenta `pypandoc` e cai para `python-docx`).  
- `preserve_images`: `true` | `false` (se true, incorpora imagens; se false, apenas referencia texto).  
- `code_style`: `plain` | `monospace` | `highlighted` (quando possível usar `pygments` para gerar imagens/estilos).  
- `title`: string para inserir no documento (se o Markdown não tiver H1).  

Bibliotecas recomendadas
- `pypandoc` (requer `pandoc` binário) — melhor qualidade de conversão, preserva estilos, tabelas e imagens automaticamente.  
- `python-docx` — criação/manipulação de .docx com controle programático, ideal como fallback.  
- `markdown` / `mistune` — para parsing quando for necessário montar o `.docx` manualmente.  
- `requests` — para baixar imagens remotas.  
- `pygments` — para destaque de sintaxe (opcional, usado para renderizar blocos de código em imagens ou HTML embutido antes de converter).

Comandos de instalação sugeridos

- Instalar pypandoc + python-docx:

    pip install pypandoc python-docx markdown requests

- Observação: `pypandoc` funciona melhor quando `pandoc` está instalado no sistema. Em Linux/Ubuntu:  

    sudo apt install pandoc

ou use o instalador oficial do Pandoc.

Fluxos de decisão (branching)
- `library==auto`: testar `import pypandoc`; se ok, usar `pypandoc.convert_file`; se `OSError` ou falta do binário, logar aviso e usar rota `python-docx`.  
- Se o Markdown contiver HTML embutido ou extensões (como footnotes), preferir `pandoc`.  
- Para muitos arquivos (batch), rodar conversão em paralelo controlado (ex.: `concurrent.futures`) com limite de I/O.

Boas práticas de mapeamento (Markdown → docx)
- H1 → estilo `Title` ou `Heading 1`; H2 → `Heading 2`, etc.  
- Parágrafos → parágrafos normais, respeitar quebras duplas.  
- Listas → listas numeradas/ não numeradas do `python-docx`.  
- Tabelas → converter células e colunas preservando formatação básica.  
- Código → inserir como parágrafo monoespaçado; opcional: gerar imagem do bloco com `pygments` e inserir, se desejar realce.  
- Imagens → incorporar ao `.docx` preferencialmente em resolução original. Baixar imagens remotas antes.

Critérios de qualidade / checagem
- Arquivo `.docx` gerado abre no Word sem erros.  
- Tabelas e imagens presentes e legíveis.  
- Títulos mapeados corretamente (Heading levels).  
- Para `pypandoc`, validar que `pypandoc.get_pandoc_version()` retorna versão esperada; se não, notificar.  

Exemplos de prompts para usar a skill
- "Converter README.md para README.docx usando pypandoc, preservando imagens."  
- "Converter docs/*.md em docx com fallback para python-docx se pandoc não estiver disponível."  
- "Gerar docx do arquivo com code_style=highlighted e incorporar imagens locais."

Exemplo de uso (pseudocódigo com pypandoc)

    import pypandoc
    output = pypandoc.convert_file('input.md', 'docx', outputfile='output.docx')

Fallback (pseudocódigo usando python-docx)

    from docx import Document
    from markdown import markdown
    # parse markdown em HTML ou AST e montar Document programaticamente

    doc = Document()
    doc.add_heading('Título', level=1)
    doc.add_paragraph('Parágrafo gerado...')
    doc.save('output.docx')

Testes e validação
- Tests unitários mínimos: converter um `.md` de exemplo e verificar que o `.docx` foi criado e contém um texto esperado (procura por substring do conteúdo).  
- Teste de integração: conversão com imagens e tabela; verificar que tamanho do arquivo > 0 e que arquivo abre com bibliotecas como `python-docx` (para leitura de conteúdo).  

Perguntas de clarificação / pontos a decidir
- Deseja suporte a tabelas complexas (mais de 10 colunas / células mescladas)?  
- Como tratar imagens remotas: incorporar automaticamente ou manter referência?  
- Deseja que os arquivos gerados usem estilos customizados do Word (ex.: fonte, tamanho) ou apenas padrões?  
- Preferência por `pandoc` como requisito de sistema ou evitar dependências externas?  

Recomendações de implementação no projeto
- Criar função utilitária em `core.py` ou `utils/docx.py`: `convert_md_to_docx(input, output=None, library='auto', **opts)` que retorna caminho do arquivo convertido.  
- Adicionar entrada em `requirements.txt` (ex.: `python-docx`, `pypandoc` opcional marcado como extra).  
- Adicionar testes em `test_core.py` com exemplos mínimos (arquivo `.md` simples) para garantir que a função retorna com sucesso.

Exemplos de prompts prontos para testar a skill
- "Implemente `convert_md_to_docx()` em `core.py` usando `pypandoc` como primeira opção e `python-docx` como fallback."  
- "Adicionar `python-docx` em `requirements.txt` e criar um teste em `test_core.py` que valida a conversão de `README.md`."

---
