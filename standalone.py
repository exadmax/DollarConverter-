import os
import requests
import tkinter as tk
from tkinter import messagebox, ttk

# Moedas disponíveis
MOEDAS = {
    "Dólar (USD)": "USD",
    "Real (BRL)": "BRL",
    "Bitcoin (BTC)": "BTC",
    "Ethereum (ETH)": "ETH",
    "BNB": "BNB",
    "Sui (SUI)": "SUI",
    "Pax Gold (PAXG)": "PAXG"
}

def obter_cotacao(origem, destino):
    try:
        url = f"https://economia.awesomeapi.com.br/json/last/{origem}-{destino}"
        resposta = requests.get(url)
        dados = resposta.json()
        chave = f"{origem}{destino}"
        return float(dados[chave]["bid"])
    except Exception as e:
        print(f"Erro ao obter cotação: {e}")
        return None

def modo_console_conversor():
    print("Modo Conversor Console")
    nomes = list(MOEDAS.keys())
    for i, moeda in enumerate(nomes, start=1):
        print(f"{i}. {moeda}")

    def selecionar_moeda(texto):
        while True:
            escolha = input(f"{texto} (1-{len(nomes)}): ")
            try:
                idx = int(escolha) - 1
                if 0 <= idx < len(nomes):
                    return MOEDAS[nomes[idx]]
            except ValueError:
                pass
            print("Opção inválida. Tente novamente.")

    origem = selecionar_moeda("Escolha a moeda de origem")
    destino = selecionar_moeda("Escolha a moeda de destino")
    valor = input("Digite o valor a converter: ")
    try:
        valor = float(valor)
        cotacao = obter_cotacao(origem, destino)
        if cotacao:
            print(f"Resultado: {valor * cotacao:.4f} {destino}")
    except Exception as e:
        print(f"Erro: {e}")

def modo_console_simulador():
    print("Modo Simulador Console")
    try:
        meta = float(input("Meta de lucro semanal (R$): "))
        rendimento = float(input("Rendimento médio semanal (%): "))
        if rendimento <= 0:
            print("Rendimento deve ser maior que zero.")
            return
        investimento = meta / (rendimento / 100)
        print(f"Para lucrar R${meta:.2f}/semana com {rendimento:.2f}%, invista R${investimento:.2f}")
    except ValueError:
        print("Valores inválidos.")

def menu_console():
    print("== MENU ==")
    print("1 - Conversor de Moedas")
    print("2 - Simulador de Lucro Semanal")
    escolha = input("Escolha uma opção: ")
    if escolha == "1":
        modo_console_conversor()
    elif escolha == "2":
        modo_console_simulador()
    else:
        print("Opção inválida.")

def abrir_simulador():
    def simular():
        try:
            meta = float(entrada_meta.get())
            rendimento = float(entrada_rendimento.get())
            if rendimento <= 0:
                resultado_simulador_var.set("Rendimento deve ser maior que zero.")
                return
            investimento = meta / (rendimento / 100)
            resultado_simulador_var.set(f"Para lucrar R${meta:.2f}/semana com {rendimento:.2f}%, invista R${investimento:.2f}")
        except ValueError:
            resultado_simulador_var.set("Preencha os campos corretamente.")

    janela_simulador = tk.Toplevel()
    janela_simulador.title("Simulador de Lucro Semanal")

    tk.Label(janela_simulador, text="Meta semanal (R$):").pack()
    entrada_meta = tk.Entry(janela_simulador)
    entrada_meta.pack()

    tk.Label(janela_simulador, text="Rendimento médio semanal (%):").pack()
    entrada_rendimento = tk.Entry(janela_simulador)
    entrada_rendimento.insert(0, "3")
    entrada_rendimento.pack()

    tk.Button(janela_simulador, text="Simular", command=simular).pack(pady=5)

    resultado_simulador_var = tk.StringVar()
    tk.Label(janela_simulador, textvariable=resultado_simulador_var, font=("Helvetica", 12)).pack(pady=10)

def abrir_conversor():
    def converter():
        try:
            valor = float(entrada_valor.get())
            origem = MOEDAS[combo_origem.get()]
            destino = MOEDAS[combo_destino.get()]
            cotacao = obter_cotacao(origem, destino)
            if cotacao:
                convertido = valor * cotacao
                resultado_var.set(f"{valor:.4f} {origem} = {convertido:.4f} {destino}")
            else:
                resultado_var.set("Erro ao buscar cotação.")
        except ValueError:
            messagebox.showwarning("Aviso", "Digite um valor válido.")

    janela_conversor = tk.Toplevel()
    janela_conversor.title("Conversor de Moedas e Criptomoedas")

    tk.Label(janela_conversor, text="Valor:").pack()
    entrada_valor = tk.Entry(janela_conversor)
    entrada_valor.pack()

    tk.Label(janela_conversor, text="De:").pack()
    combo_origem = ttk.Combobox(
        janela_conversor, values=list(MOEDAS.keys()), state="readonly"
    )
    combo_origem.current(0)
    combo_origem.pack()

    tk.Label(janela_conversor, text="Para:").pack()
    combo_destino = ttk.Combobox(
        janela_conversor, values=list(MOEDAS.keys()), state="readonly"
    )
    combo_destino.current(1)
    combo_destino.pack()

    tk.Button(janela_conversor, text="Converter", command=converter).pack(pady=5)

    resultado_var = tk.StringVar()
    tk.Label(janela_conversor, textvariable=resultado_var, font=("Helvetica", 14)).pack(pady=10)

def menu_gui():
    janela_menu = tk.Tk()
    janela_menu.title("Menu")

    tk.Label(janela_menu, text="Escolha uma opção:", font=("Helvetica", 14)).pack(pady=20)
    tk.Button(janela_menu, text="Conversor de Moedas", command=abrir_conversor, width=30).pack(pady=10)
    tk.Button(janela_menu, text="Simulador de Lucro Semanal", command=abrir_simulador, width=30).pack(pady=10)

    janela_menu.mainloop()

if __name__ == "__main__":
    try:
        if os.environ.get("DISPLAY") or os.name == "nt":
            menu_gui()
        else:
            raise Exception("Sem display")
    except Exception:
        menu_console()
