import requests

# Currency code to display name mapping
CURRENCIES = {
    "USD": "Dólar",
    "BRL": "Real",
    "BTC": "Bitcoin",
    "ETH": "Ethereum",
    "BNB": "BNB",
    "SUI": "Sui",
    "PAXG": "Pax Gold",
}

FORMATTED_TO_CODE = {f"{name} ({code})": code for code, name in CURRENCIES.items()}


def get_exchange_rate(origem: str, destino: str) -> float:
    """Return the exchange rate from origem to destino using AwesomeAPI."""
    url = f"https://economia.awesomeapi.com.br/json/last/{origem}-{destino}"
    response = requests.get(url, timeout=10)
    response.raise_for_status()
    data = response.json()
    key = f"{origem}{destino}"
    if key not in data:
        raise ValueError("Par de moedas inválido")
    return float(data[key]["bid"])


def convert(value: float, origem: str, destino: str, rate: float | None = None) -> float:
    """Convert value from origem to destino. If rate is None, fetch it."""
    if rate is None:
        rate = get_exchange_rate(origem, destino)
    return value * rate


def investment_for_weekly_profit(target: float, weekly_return_percent: float) -> float:
    """Calculate the investment needed for a desired weekly profit."""
    if weekly_return_percent <= 0:
        raise ValueError("Rendimento deve ser maior que zero.")
    return target / (weekly_return_percent / 100)

