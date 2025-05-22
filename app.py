import os
import requests
import tkinter as tk
from tkinter import messagebox

def obter_cotacao_dolar():
    try:
        url = "https://economia.awesomeapi.com.br/json/last/USD-BRL"
        resposta = requests.get(url)
        dados = resposta.json()
        return float(dados["USDBRL"]["bid"])
    except Exception as e:
        print(f"Erro ao obter cotação do dólar: {e}")
        return None

def modo_console():
    print("Modo console ativado (sem suporte a interface gráfica).")
    valor = input("Digite o valor em dólar: ")
    try:
        valor_dolar = float(valor)
        cotacao = obter_cotacao_dolar()
        if cotacao:
            valor_reais = valor_dolar * cotacao
            print(f"Valor em reais: R$ {valor_reais:.2f}")
    except ValueError:
        print("Valor inválido.")

def modo_tkinter():
    def converter():
        try:
            valor_dolar = float(entrada_dolar.get())
            cotacao = obter_cotacao_dolar()
            if cotacao:
                valor_reais = valor_dolar * cotacao
                resultado_var.set(f"R$ {valor_reais:.2f}")
        except ValueError:
            messagebox.showwarning("Aviso", "Digite um valor válido em dólar.")

    janela = tk.Tk()
    janela.title("Conversor Dólar para Real")

    tk.Label(janela, text="Valor em Dólar (US$):").pack()
    entrada_dolar = tk.Entry(janela)
    entrada_dolar.pack()
    tk.Button(janela, text="Converter", command=converter).pack(pady=5)

    resultado_var = tk.StringVar()
    tk.Label(janela, textvariable=resultado_var, font=("Helvetica", 16)).pack(pady=10)

    janela.mainloop()

if __name__ == "__main__":
    try:
        # Tenta iniciar o modo gráfico
        if os.environ.get("DISPLAY") or os.name == "nt":  # Windows geralmente tem GUI
            modo_tkinter()
        else:
            raise Exception("Sem display")
    except Exception:
        modo_console()
