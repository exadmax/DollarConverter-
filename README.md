![Python](https://img.shields.io/badge/python-3.8%2B-blue?logo=python)
![Flutter](https://img.shields.io/badge/flutter-web-blue?logo=flutter)
![License](https://img.shields.io/github/license/exadmax/DollarConverter-)
![Last Commit](https://img.shields.io/github/last-commit/exadmax/DollarConverter-)
![Repo Size](https://img.shields.io/github/repo-size/exadmax/DollarConverter-)
![Issues](https://img.shields.io/github/issues/exadmax/DollarConverter-)


# 💱 InvestWatch — Conversor de Moedas, Ibovespa e Simulador de Lucros

Este repositório reúne duas aplicações independentes que compartilham a mesma ideia: acompanhar cotações de moedas/criptomoedas e ações da B3, converter valores e simular metas de lucro semanal.

- **App Web (Flutter)** — em [`app/`](app/). Dashboard de observação (watchlist) de moedas, criptomoedas, o índice Ibovespa e ações da B3, com conversor e simulador. Não requer login: o usuário adiciona/remove itens da watchlist e as preferências ficam salvas no próprio navegador (localStorage). É publicado automaticamente no **GitHub Pages**.
- **App Desktop (Python)** — `standalone.py` + `core.py`, interface Tkinter (GUI) com fallback em modo texto (console).

> A versão web em Flask (`web.py` + `templates/`) foi descontinuada e removida em favor do app Flutter, que roda inteiramente no navegador (sem servidor/backend) e pode ser hospedado como site estático.

---

## 🌐 App Web (Flutter) — `app/`

### Funcionalidades
- **Monitor/Dashboard**: watchlist de moedas/criptos e ações B3 + índice Ibovespa, com preços atualizados automaticamente a cada 5 minutos.
- **Adicionar itens**: o usuário pode adicionar qualquer código de moeda (validado via AwesomeAPI) ou ticker da B3 (validado via brapi.dev) à sua watchlist.
- **Persistência sem login**: a watchlist é salva no navegador do usuário (localStorage), sem conta nem servidor.
- **Conversor de moedas**: mesma lógica de conversão do app original (fallback via USD para pares BRL indisponíveis).
- **Simulador de lucro semanal**.
- **Valorização mensal**: gráfico de variação percentual de moedas e ações (dados ilustrativos offline).

### Origem dos dados
Os preços são buscados **diretamente do navegador**, sem servidor intermediário:
- Câmbio/cripto: [AwesomeAPI](https://docs.awesomeapi.com.br/api-de-moedas)
- Ações B3 e Ibovespa: [brapi.dev](https://brapi.dev/)

Quando uma API está indisponível, os itens conhecidos (moedas e ações padrão) caem para uma tabela offline ilustrativa embutida no app.

### Rodar localmente
```bash
cd app
flutter pub get
flutter run -d chrome
```

### Build de produção
```bash
cd app
flutter build web --release
```

### Deploy no GitHub Pages
O workflow [`.github/workflows/deploy.yml`](.github/workflows/deploy.yml) builda o app Flutter e publica em GitHub Pages a cada push em `main` que altere `app/`. Para ativar:
1. Nas configurações do repositório, em **Settings → Pages**, defina a fonte como **GitHub Actions**.
2. Faça push para `main` (ou dispare manualmente em **Actions → Deploy Flutter Web to GitHub Pages → Run workflow**).

---

## 🖥️ App Desktop (Python) — `standalone.py`

### Requisitos
- Python 3.8+
- `pip install -r requirements.txt`
- `tkinter` (já incluso no Python para Windows/Linux)

### Executar
```bash
python standalone.py
```
Detecta automaticamente se deve abrir a interface gráfica (Tkinter) ou o modo texto (console).

### Testes
```bash
python -m unittest
```

### Build Windows Executable
```cmd
build_windows.bat
```
O executável `DollarConverter.exe` fica disponível em `dist/`.

---

## 📁 Estrutura do Projeto

```
app/                    # App web em Flutter (dashboard, conversor, simulador, gráficos)
standalone.py           # App desktop: GUI (Tkinter) + console
core.py                 # Lógica de conversão e simulação usada pelo app desktop
test_core.py            # Testes unitários do core.py
.github/workflows/      # Pipeline de build e deploy do app Flutter no GitHub Pages
```
