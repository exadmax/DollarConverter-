from flask import Flask, render_template, request
from datetime import datetime
import requests

app = Flask(__name__)

MOEDAS = {
    "USD": "Dólar",
    "BRL": "Real",
    "BTC": "Bitcoin",
    "ETH": "Ethereum",
    "BNB": "BNB",
    "SUI": "Sui",
    "PAXG": "Pax Gold"
}

def obter_cotacao(origem, destino):
    try:
        url = f"https://economia.awesomeapi.com.br/json/last/{origem}-{destino}"
        resposta = requests.get(url)
        dados = resposta.json()
        chave = f"{origem}{destino}"
        return float(dados[chave]["bid"])
    except:
        return None

def salvar_historico(origem, destino, valor, convertido, cotacao):
    data = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    with open("historico.txt", "a", encoding="utf-8") as f:
        f.write(f"[{data}] {valor} {origem} -> {convertido:.2f} {destino} (cotação: {cotacao})\n")

@app.route("/simulador", methods=["GET", "POST"])
def simulador():
    resultado = ""
    if request.method == "POST":
        try:
            meta_reais = float(request.form.get("meta"))
            rendimento = float(request.form.get("rendimento"))

            if rendimento <= 0:
                resultado = "Rendimento deve ser maior que zero."
            else:
                investimento_necessario = meta_reais / (rendimento / 100)
                resultado = f"✅ Para lucrar R${meta_reais:.2f}/semana com {rendimento:.2f}%, você precisa investir R${investimento_necessario:.2f}"
        except ValueError:
            resultado = "Preencha os campos corretamente."

    return render_template("simulador.html", resultado=resultado)



@app.route("/", methods=["GET", "POST"])
def index():
    resultado = ""
    if request.method == "POST":
        valor = request.form.get("valor")
        de = request.form.get("de")
        para = request.form.get("para")
        try:
            valor_float = float(valor)
            cotacao = obter_cotacao(de, para)
            if cotacao:
                convertido = valor_float * cotacao
                resultado = f"{valor_float:.4f} {de} = {convertido:.4f} {para}"
                salvar_historico(de, para, valor_float, convertido, cotacao)
            else:
                resultado = "Erro ao buscar cotação."
        except ValueError:
            resultado = "Valor inválido."

    return render_template("index.html", moedas=MOEDAS, resultado=resultado)

if __name__ == "__main__":
    app.run(debug=True)