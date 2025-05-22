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
        messagebox.showerror("Erro", f"Erro ao obter cotação do dólar:\n{e}")
        return None

def converter():
    try:
        valor_dolar = float(entrada_dolar.get())
        cotacao = obter_cotacao_dolar()
        if cotacao:
            valor_reais = valor_dolar * cotacao
            resultado_var.set(f"R$ {valor_reais:.2f}")
    except ValueError:
        messagebox.showwarning("Aviso", "Digite um valor válido em dólar.")

# Interface
janela = tk.Tk()
janela.title("Conversor Dólar para Real")

tk.Label(janela, text="Valor em Dólar (US$):").pack()

entrada_dolar = tk.Entry(janela)
entrada_dolar.pack()

tk.Button(janela, text="Converter", command=converter).pack(pady=5)

resultado_var = tk.StringVar()
tk.Label(janela, textvariable=resultado_var, font=("Helvetica", 16)).pack(pady=10)

janela.mainloop()
