from flask import Flask, render_template, request
from datetime import datetime

import core

app = Flask(__name__)

MOEDAS = core.CURRENCIES


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

            investimento_necessario = core.investment_for_weekly_profit(meta_reais, rendimento)
            resultado = (
                f"✅ Para lucrar R${meta_reais:.2f}/semana com {rendimento:.2f}%, "
                f"você precisa investir R${investimento_necessario:.2f}"
            )
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
            convertido = core.convert(valor_float, de, para)
            resultado = f"{valor_float:.4f} {de} = {convertido:.4f} {para}"
            salvar_historico(de, para, valor_float, convertido, core.get_exchange_rate(de, para))
        except Exception:
            resultado = "Valor inválido."

    return render_template("index.html", moedas=MOEDAS, resultado=resultado)

if __name__ == "__main__":
    app.run(debug=True)
