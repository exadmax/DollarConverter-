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

# Example monthly price history (in BRL) for the last 6 months. These are
# illustrative offline values used when real data is unavailable.
CURRENCY_HISTORY_BRL = {
    "USD": [5.0, 5.1, 5.2, 5.3, 5.4, 5.45],
    "BTC": [120000, 122000, 125000, 123000, 128000, 130000],
    "ETH": [9000, 9200, 9100, 9400, 9500, 9600],
    "BNB": [1500, 1520, 1550, 1540, 1580, 1600],
    "SUI": [10, 10.5, 10.8, 10.3, 10.6, 10.9],
    "PAXG": [9500, 9600, 9700, 9650, 9750, 9800],
    "BRL": [1, 1, 1, 1, 1, 1],
}


def get_exchange_rate(origem: str, destino: str) -> float:
    """Return the exchange rate from origem to destino using AwesomeAPI."""
    url = f"https://economia.awesomeapi.com.br/json/last/{origem}-{destino}"
    try:
        response = requests.get(url, timeout=10)
        response.raise_for_status()
        data = response.json()
    except requests.RequestException as exc:
        raise ConnectionError("API de cotações indisponível") from exc
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
    "PETR4": {
        "name": "Petrobras PN",
        "price_brl": 37.50,
        "weekly_return": 2.1,
        "monthly": [34.0, 35.0, 36.2, 37.0, 37.5, 38.0],
    },
    "VALE3": {
        "name": "Vale ON",
        "price_brl": 62.00,
        "weekly_return": -1.2,
        "monthly": [60.0, 61.0, 63.0, 62.5, 62.0, 63.5],
    },
    "ABEV3": {
        "name": "Ambev ON",
        "price_brl": 14.20,
        "weekly_return": 0.8,
        "monthly": [13.5, 13.8, 14.0, 14.1, 14.2, 14.3],
    },
}


def get_b3_stocks() -> dict:
    """Return mapping of B3 tickers to info."""
    return B3_STOCKS


def get_b3_stock_info(ticker: str) -> dict:
    """Return information for a B3 stock ticker."""
    if ticker not in B3_STOCKS:
        raise ValueError("Ticker inválido")
    return B3_STOCKS[ticker]


def _calc_appreciation(history: list[float]) -> list[float]:
    """Return percentage change between consecutive entries."""
    return [
        (history[i] - history[i - 1]) / history[i - 1] * 100
        for i in range(1, len(history))
    ]


def get_currency_monthly_appreciation(code: str) -> list[float]:
    """Return monthly appreciation percentages for the given currency."""
    hist = CURRENCY_HISTORY_BRL.get(code)
    if not hist:
        raise ValueError("Moeda inválida")
    return _calc_appreciation(hist)


def get_stock_monthly_appreciation(ticker: str) -> list[float]:
    """Return monthly appreciation percentages for a B3 stock."""
    info = get_b3_stock_info(ticker)
    hist = info.get("monthly")
    if not hist:
        raise ValueError("Histórico indisponível")
    return _calc_appreciation(hist)


