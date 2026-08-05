Estou redesenhando a UI/UX de um app web (Flutter Web) chamado **InvestWatch** —
um dashboard de observação de investimentos, sem login, focado em consulta rápida
de preços. Quero um redesign visual completo, mantendo as telas e fluxos abaixo.

## Contexto do produto
- Público: pessoa física acompanhando cripto, câmbio e bolsa brasileira no dia a dia.
- Sem conta/login. Tudo é salvo localmente no navegador do usuário.
- Uso típico: abrir o app, bater o olho nos preços que importam pra ela, sair.
  Prioridade máxima é escaneabilidade e clareza de números (leitura em 2 segundos).

## Telas existentes (manter a função, redesenhar a forma)
1. **Monitor/Dashboard** (tela principal): lista de moedas/criptos favoritas +
   índices fixos (Ibovespa, IFIX, S&P 500) + ações da B3 favoritas, cada item
   com preço atual em destaque. Atualiza sozinho a cada 5 min. Tem botão de
   adicionar novo item em cada seção (moedas / ações). Cada item pode ser removido.
2. **Conversor**: campo de valor + dois seletores (moeda de origem/destino) + botão
   converter + resultado.
3. **Simulador de lucro semanal**: dois campos (meta de lucro em R$, rendimento % 
   semanal) + botão + resultado explicando quanto investir.
4. **Ações B3**: lista completa de ações disponíveis com preço, rendimento semanal
   e botão de favoritar (estrela) pra mandar pro dashboard.
5. **Valorização mensal**: gráfico de linha mostrando variação % mês a mês de uma
   moeda ou ação selecionada (dropdown de seleção + toggle moedas/ações).

## O que preciso que você entregue
- Um sistema visual coeso (paleta, tipografia, espaçamento, elevação/sombras,
  border-radius) que funcione bem em tema claro E escuro.
- Componentes-chave redesenhados: o card de preço (item da watchlist), os campos
  de formulário do conversor/simulador, o gráfico de valorização, e a navegação
  entre as 5 telas (hoje é uma bottom nav / rail lateral simples).
- Tratamento visual claro para: números subindo (verde) vs caindo (vermelho),
  estado de carregamento, e estado "indisponível" (quando uma cotação falha e
  cai pro valor offline).
- Ícones e microcopy em português do Brasil.
- Layout responsivo: funciona tanto em mobile quanto em desktop/web wide (o app
  já alterna entre bottom nav no mobile e nav rail lateral no desktop >= 720px).

## Não mude
- A estrutura de informação / os dados mostrados em cada tela (isso é o dev que
  decide) — quero só o redesign visual e de interação, não uma reformulação de
  produto.
