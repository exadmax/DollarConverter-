from flask import Flask, render_template, request
from datetime import datetime

import core

app = Flask(__name__)

MOEDAS = core.CURRENCIES
ACOES = core.get_b3_stocks()


def salvar_historico(origem, destino, valor, convertido, cotacao):
    data = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    try:
        with open("historico.txt", "a", encoding="utf-8") as f:
            f.write(
                f"[{data}] {valor} {origem} -> {convertido:.2f} {destino} (cotação: {cotacao})\n"
            )
    except OSError:
        # Falha ao salvar o histórico não deve interromper a aplicação
        pass

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


@app.route("/b3", methods=["GET"])
def b3():
    dados = {}
    for tic, info in ACOES.items():
        try:
            preco = core.get_b3_stock_price_brl(tic)
        except ConnectionError:
            preco = info["price_brl"]
        dados[tic] = {**info, "price_brl": preco}
    return render_template("b3.html", acoes=dados)


@app.route("/moedas")
def moedas():
    dados = {
        code: core.get_currency_monthly_appreciation(code)
        for code in MOEDAS.keys()
    }
    return render_template("moedas.html", dados=dados)


@app.route("/b3_valorizacao")
def b3_valorizacao():
    dados = {
        t: core.get_stock_monthly_appreciation(t)
        for t in ACOES.keys()
    }
    return render_template("b3_val.html", dados=dados)


@app.route("/monitor")
def monitor():
    dados = core.gather_monitor_data()
    return render_template("monitor.html", dados=dados)



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
        except ConnectionError:
            resultado = "API de cotações indisponível."
        except Exception:
            resultado = "Valor inválido."

    return render_template("index.html", moedas=MOEDAS, resultado=resultado)

if __name__ == "__main__":
    app.run(debug=True)
