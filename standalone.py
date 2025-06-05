import os
import tkinter as tk
from tkinter import messagebox, ttk

import core

# Mapping of formatted currency name to code used in the interfaces
MOEDAS = core.FORMATTED_TO_CODE
ACAO_INFO = core.get_b3_stocks()

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
        convertido = core.convert(valor, origem, destino)
        print(f"Resultado: {convertido:.4f} {destino}")
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
        investimento = core.investment_for_weekly_profit(meta, rendimento)
        print(
            f"Para lucrar R${meta:.2f}/semana com {rendimento:.2f}%, invista R${investimento:.2f}"
        )
    except ValueError:
        print("Valores inválidos.")


def modo_console_b3():
    print("Ações da B3")
    tickers = list(ACAO_INFO.keys())
    for i, tic in enumerate(tickers, start=1):
        info = ACAO_INFO[tic]
        print(f"{i}. {tic} - {info['name']}")

    while True:
        escolha = input(f"Selecione a ação (1-{len(tickers)}): ")
        try:
            idx = int(escolha) - 1
            if 0 <= idx < len(tickers):
                acao = ACAO_INFO[tickers[idx]]
                print(
                    f"Preço: R${acao['price_brl']:.2f} | Rendimento semanal: {acao['weekly_return']:.2f}%"
                )
                break
        except ValueError:
            pass
        print("Opção inválida. Tente novamente.")

def menu_console():
    print("== MENU ==")
    print("1 - Conversor de Moedas")
    print("2 - Simulador de Lucro Semanal")
    print("3 - Ações da B3")
    escolha = input("Escolha uma opção: ")
    if escolha == "1":
        modo_console_conversor()
    elif escolha == "2":
        modo_console_simulador()
    elif escolha == "3":
        modo_console_b3()
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
            investimento = core.investment_for_weekly_profit(meta, rendimento)
            resultado_simulador_var.set(
                f"Para lucrar R${meta:.2f}/semana com {rendimento:.2f}%, invista R${investimento:.2f}"
            )
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
            convertido = core.convert(valor, origem, destino)
            resultado_var.set(
                f"{valor:.4f} {origem} = {convertido:.4f} {destino}"
            )
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


def abrir_b3():
    janela_b3 = tk.Toplevel()
    janela_b3.title("Ações da B3")

    tk.Label(janela_b3, text="Selecione a ação:").pack()
    tickers = list(ACAO_INFO.keys())
    combo = ttk.Combobox(janela_b3, values=tickers, state="readonly")
    combo.current(0)
    combo.pack()

    texto_var = tk.StringVar()

    def mostrar(*args):
        info = ACAO_INFO[combo.get()]
        texto_var.set(
            f"Preço: R${info['price_brl']:.2f} | Rendimento semanal: {info['weekly_return']:.2f}%"
        )

    combo.bind("<<ComboboxSelected>>", mostrar)
    mostrar()
    tk.Label(janela_b3, textvariable=texto_var, font=("Helvetica", 12)).pack(pady=10)

def menu_gui():
    janela_menu = tk.Tk()
    janela_menu.title("Menu")

    tk.Label(janela_menu, text="Escolha uma opção:", font=("Helvetica", 14)).pack(pady=20)
    tk.Button(janela_menu, text="Conversor de Moedas", command=abrir_conversor, width=30).pack(pady=10)
    tk.Button(janela_menu, text="Simulador de Lucro Semanal", command=abrir_simulador, width=30).pack(pady=10)
    tk.Button(janela_menu, text="Ações da B3", command=abrir_b3, width=30).pack(pady=10)

    janela_menu.mainloop()

if __name__ == "__main__":
    try:
        if os.environ.get("DISPLAY") or os.name == "nt":
            menu_gui()
        else:
            raise Exception("Sem display")
    except Exception:
        menu_console()

