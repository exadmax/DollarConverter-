---
name: commit-on-complete
applyTo: "**/*.py"
description: "Instruções para o agente: ao finalizar e completar a implementação de funções, realizar commit e push no GitHub somente se o projeto se apresentar estável."
---

**Objetivo**
- Garantir que alterações realizadas pelo agente sejam versionadas automaticamente quando for seguro fazê-lo: ou seja, quando o projeto estiver estável (testes passam e checks básicos OK).

**Quando aplicar**
- Ao terminar de implementar ou completar uma função/module solicitado pelo usuário.
- Só aplicar para modificações locais que mudem código (não para alterações triviais de documentação, a menos que o usuário peça).

**Critério de "Projeto Estável" (checagens obrigatórias)**
- Executar `python -m unittest` e confirmar saída sem falhas (todos os testes OK).
- Confirmar que `git status --porcelain` apresenta mudanças a serem commitadas.
- Opcional (se disponível): executar linters/formatters configurados no projeto (ex.: `flake8`, `black --check`) e garantir que não haja erros.
- Não proceder se houver testes falhando, erros de lint configurados como bloqueantes, ou se o repositório remoto estiver protegido contra pushes diretos na branch atual.

**Passo a passo que o agente deve seguir antes de commit/push**
1. Verificar se há mudanças: `git status --porcelain`.
2. Rodar `python -m unittest` (ou comando de teste do projeto) e assegurar que tudo passou. Se falhar, abortar commit/push e reportar os resultados ao usuário com diagnóstico.
3. Opcional: executar checks adicionais (linters/formatters) se estiverem configurados.
4. Preparar um commit com mensagem clara e padronizada. Sugestão de formato: `feat(agent): implementar <descrição curta>` ou `fix(agent): corrigir <descrição curta>`.
5. Se o repositório remoto requer revisão (ex.: branch protegida), criar uma nova branch e abrir um pull request em vez de push direto. Se possível, usar `gh` CLI para automatizar: `gh pr create --fill`.
6. Fazer `git push` para a branch correspondente.
7. Informar ao usuário o resumo do commit (hash, mensagem, branch) e link para o PR ou commit no GitHub.

**Regras de segurança / exceções**
- Nunca commitar credenciais, tokens ou arquivos sensíveis. Antes do commit, rodar uma checagem simples por padrões óbvios (`.env`, `KEY=`, `SECRET=`). Se encontrados, remover ou solicitar orientação ao usuário.
- Se os testes inexistirem no projeto (nenhum teste detectado), NÃO fazer push automático; perguntar ao usuário se deve proceder mesmo assim.
- Em caso de conflitos com a branch remota ou push rejeitado, não forçar o push; reportar o problema e pedir instruções.

**Interação com o usuário**
- Se a alteração for pequena e os testes passarem, pode commitar automaticamente usando a mensagem padrão.
- Se a alteração for estrutural ou grande, ou se houver múltiplos commits locais, perguntar antes de push.
- Sempre mostrar um resumo antes do push e pedir confirmação quando houver risco (ex.: testes faltantes, alterações sensíveis).

**Exemplos de prompts que disparam essa instrução**
- "Implemente a função X e, quando pronto, commite e faça push se os testes passarem."  
- "Finalize o conversor e envie as mudanças para o GitHub, somente se o projeto estiver estável."  

**Comandos sugeridos (execução segura)**
- Verificar mudanças:

    git status --porcelain

- Rodar testes:

    python -m unittest

- Commit e push (exemplo automatizado simples):

    git add -A
    git commit -m "feat(agent): implementar <descrição>"
    git push origin HEAD

- Criar branch + PR (quando apropriado):

    git checkout -b feat/descricao-curta
    git add -A
    git commit -m "feat(agent): implementar <descrição>"
    git push -u origin feat/descricao-curta
    gh pr create --fill

**Observações finais**
- Esta instrução é um comportamento preferencial: o agente deve sempre priorizar a segurança (não quebrar a árvore). Se houver dúvidas sobre estabilidade, perguntar ao usuário.
- Se você deseja que o agente automatize esses passos agora (por exemplo, commitar e push das mudanças atuais), responda afirmativamente e o agente executará os checks e procederá conforme o resultado.
