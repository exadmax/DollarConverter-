![Python](https://img.shields.io/badge/python-3.8%2B-blue?logo=python)
![License](https://img.shields.io/github/license/exadmax/DollarConverter-)
![Last Commit](https://img.shields.io/github/last-commit/exadmax/DollarConverter-)
![Repo Size](https://img.shields.io/github/repo-size/exadmax/DollarConverter-)
![Issues](https://img.shields.io/github/issues/exadmax/DollarConverter-)


# 💱 Conversor de Moedas e Simulador de Lucros Semanais

Aplicativo Python que permite a conversão entre moedas tradicionais e criptomoedas, além de simular quanto você precisa investir para alcançar uma meta de lucro semanal com base em um rendimento percentual estimado.

> Funciona em dois modos: interface gráfica (Tkinter) ou modo texto (console), dependendo do ambiente. Também há uma **versão web (Flask)** para rodar via navegador ou WebView em Android.

---

## 🧩 Funcionalidades

### 🪙 Conversor de Moedas
- Converte entre:
  - Dólar (USD)
  - Real (BRL)
  - Bitcoin (BTC)
  - Ethereum (ETH)
  - BNB
  - Sui (SUI)
  - Pax Gold (PAXG)
- Utiliza cotações em tempo real via [AwesomeAPI](https://docs.awesomeapi.com.br/api-de-moedas)

### 📈 Simulador de Lucro Semanal
- Calcula quanto investir para atingir uma meta semanal de lucro
- Baseado em um rendimento percentual médio ajustável (ex: 3%/semana)
- Interface intuitiva tanto no terminal quanto na GUI

### 🌐 Versão Web (Flask)
- Interface web com as mesmas funcionalidades
- Ideal para uso em navegador ou via WebView Android

### 🧠 Modo Inteligente
- Detecta automaticamente se deve usar interface gráfica ou terminal
- Menu inicial para escolher entre conversor ou simulador

---

## 🖥️ Como executar

### Requisitos
- Python 3.8+
- `requests` (instale com `pip install requests`)
- `tkinter` (já incluso no Python para Windows/Linux)
- `flask` (apenas para a versão web)

### Executar app desktop (GUI ou terminal)
```bash
python standalone.py
```

### Executar versão web
```bash
python web.py
```
Acesse: http://127.0.0.1:5000

---

## 📁 Estrutura do Projeto

```
standalone.py          # Código principal com GUI e console
web.py                 # Versão web com Flask
templates/             # HTMLs para a versão web
historico.txt          # (opcional) log das conversões
```

---

# 💱 Currency Converter & Weekly Profit Simulator

A Python application to convert between fiat currencies and cryptocurrencies, and simulate how much to invest to reach a weekly profit goal based on estimated return.

> Works in GUI (Tkinter), terminal, and also includes a **Flask web version** for browser or Android WebView use.

---

## 🧩 Features

### 🪙 Currency Converter
- Convert between:
  - US Dollar (USD)
  - Brazilian Real (BRL)
  - Bitcoin (BTC)
  - Ethereum (ETH)
  - BNB
  - Sui (SUI)
  - Pax Gold (PAXG)
- Uses real-time exchange rates from [AwesomeAPI](https://docs.awesomeapi.com.br/api-de-moedas)

### 📈 Weekly Profit Simulator
- Calculates required investment for a target weekly profit
- Based on customizable weekly return rate (e.g. 3%/week)
- Available in both terminal and GUI

### 🌐 Web Version (Flask)
- Full-featured web interface
- Ideal for use in browser or Android WebView

### 🧠 Smart Mode
- Auto-detects whether to run GUI or console
- Menu allows choosing between converter or simulator

### 📊 B3 Stocks
- View example prices of popular B3 tickers in BRL
- Weekly return percentages displayed

---

## 🖥️ How to Run

### Requirements
- Python 3.8+
- Install dependencies with `pip install -r requirements.txt`
- `tkinter` (bundled with most Python installs)

### Run Desktop App (GUI or CLI)
```bash
python standalone.py
```
The application chooses GUI or CLI automatically depending on your environment.
Use the menu to access the currency converter, the profit simulator or the B3 stock list.

### Run Web Version
```bash
python web.py
```
Access: http://127.0.0.1:5000
Navigate to `/b3` for the B3 stocks page.

### Run Tests
```bash
python -m unittest
```

### Build Windows Executable
Use [PyInstaller](https://pyinstaller.org/) to bundle the application into a
single Windows binary. From a Windows command prompt run:
```cmd
build_windows.bat
```
The generated `DollarConverter.exe` will be available in the `dist` folder.

### Deployment
The Flask web app requires a Python server and therefore cannot run directly on
GitHub Pages. To make it accessible online you can deploy it on services such as
[Render](https://render.com/) or [Fly.io](https://fly.io/). GitHub Pages can be
used to host the static HTML under `templates/`, but a Python backend is still
needed for the conversions.

---

## 📁 Project Structure

```
standalone.py          # Main code with GUI + CLI
web.py                 # Flask-based web version
templates/             # HTML templates for web UI
historico.txt          # (optional) conversion history
core.py                # Shared conversion and simulation logic
test_core.py           # Unit tests for core functions
```
