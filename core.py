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


# =========================== B3 stock data ============================
# In environments without internet access we keep a small offline table
# with example prices (in BRL) and estimated weekly returns.  These
# values are merely illustrative.
B3_STOCKS = {
    "PETR4": {"name": "Petrobras PN", "price_brl": 37.50, "weekly_return": 2.1},
    "VALE3": {"name": "Vale ON", "price_brl": 62.00, "weekly_return": -1.2},
    "ABEV3": {"name": "Ambev ON", "price_brl": 14.20, "weekly_return": 0.8},
}


def get_b3_stocks() -> dict:
    """Return mapping of B3 tickers to info."""
    return B3_STOCKS


def get_b3_stock_info(ticker: str) -> dict:
    """Return information for a B3 stock ticker."""
    if ticker not in B3_STOCKS:
        raise ValueError("Ticker inválido")
    return B3_STOCKS[ticker]


