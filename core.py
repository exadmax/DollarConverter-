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
    """Convert value from origem to destino. If rate is None, fetch it.

    When converting to BRL and a direct pair is unavailable, the
    conversion is attempted via USD.
    """
    if rate is None:
        try:
            rate = get_exchange_rate(origem, destino)
        except ValueError:
            if destino == "BRL" and origem != "BRL":
                usd_rate = get_exchange_rate(origem, "USD")
                brl_rate = get_exchange_rate("USD", "BRL")
                rate = usd_rate * brl_rate
            else:
                raise
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
    "KNCR11": {
        "name": "Kinea Rendimentos",
        "price_brl": 115.00,
        "weekly_return": 0.5,
        "monthly": [110, 111, 112, 113, 114, 115],
    },
    "ITUB4": {
        "name": "Itaú Unibanco PN",
        "price_brl": 30.00,
        "weekly_return": 1.2,
        "monthly": [27, 28, 29, 29.5, 29.8, 30],
    },
    "BBDC4": {
        "name": "Bradesco PN",
        "price_brl": 17.00,
        "weekly_return": 1.1,
        "monthly": [15.5, 16, 16.2, 16.7, 16.9, 17],
    },
    "BBAS3": {
        "name": "Banco do Brasil ON",
        "price_brl": 48.00,
        "weekly_return": 1.8,
        "monthly": [45, 46, 47, 47.5, 48, 48.5],
    },
    "WEGE3": {
        "name": "WEG ON",
        "price_brl": 37.00,
        "weekly_return": 1.5,
        "monthly": [33, 34, 35, 36, 36.5, 37],
    },
    "MGLU3": {
        "name": "Magazine Luiza ON",
        "price_brl": 3.20,
        "weekly_return": 2.5,
        "monthly": [2.5, 2.6, 2.8, 3.0, 3.1, 3.2],
    },
    "B3SA3": {
        "name": "B3 ON",
        "price_brl": 13.20,
        "weekly_return": 1.0,
        "monthly": [12, 12.3, 12.7, 12.9, 13.1, 13.2],
    },
    "LREN3": {
        "name": "Lojas Renner ON",
        "price_brl": 21.00,
        "weekly_return": 1.4,
        "monthly": [19, 19.8, 20.2, 20.7, 20.9, 21],
    },
    "SUZB3": {
        "name": "Suzano ON",
        "price_brl": 55.00,
        "weekly_return": 1.3,
        "monthly": [50, 51, 52.5, 53, 54, 55],
    },
    "GGBR4": {
        "name": "Gerdau PN",
        "price_brl": 15.00,
        "weekly_return": 1.2,
        "monthly": [13.5, 14, 14.2, 14.5, 14.8, 15],
    },
    "USIM5": {
        "name": "Usiminas PNA",
        "price_brl": 7.50,
        "weekly_return": 1.1,
        "monthly": [6.5, 6.8, 7, 7.2, 7.4, 7.5],
    },
    "CSNA3": {
        "name": "CSN ON",
        "price_brl": 18.00,
        "weekly_return": 1.5,
        "monthly": [16, 16.5, 17, 17.5, 17.8, 18],
    },
    "JBS3": {
        "name": "JBS ON",
        "price_brl": 33.00,
        "weekly_return": 1.2,
        "monthly": [30, 30.8, 31.5, 32, 32.5, 33],
    },
    "LWSA3": {
        "name": "LWSA ON",
        "price_brl": 5.00,
        "weekly_return": 1.3,
        "monthly": [4.2, 4.4, 4.6, 4.7, 4.9, 5.0],
    },
    "PETZ3": {
        "name": "Petz ON",
        "price_brl": 6.30,
        "weekly_return": 0.9,
        "monthly": [5.5, 5.7, 5.8, 6.0, 6.2, 6.3],
    },
    "YDUQ3": {
        "name": "Yduqs ON",
        "price_brl": 18.00,
        "weekly_return": 1.7,
        "monthly": [16, 16.5, 17, 17.5, 17.8, 18],
    },
    "SLCE3": {
        "name": "SLC Agrícola ON",
        "price_brl": 41.00,
        "weekly_return": 1.4,
        "monthly": [37, 38, 39, 39.5, 40, 41],
    },
    "PRIO3": {
        "name": "PRIO ON",
        "price_brl": 40.00,
        "weekly_return": 2.2,
        "monthly": [34, 36, 37, 38, 39, 40],
    },
    "HAPV3": {
        "name": "Hapvida ON",
        "price_brl": 7.00,
        "weekly_return": 1.6,
        "monthly": [5.8, 6.2, 6.5, 6.8, 6.9, 7],
    },
    "EGIE3": {
        "name": "Engie Brasil ON",
        "price_brl": 43.00,
        "weekly_return": 0.8,
        "monthly": [41, 41.5, 42, 42.5, 42.8, 43],
    },
    "NTCO3": {
        "name": "Natura ON",
        "price_brl": 15.00,
        "weekly_return": 1.5,
        "monthly": [13, 13.5, 14, 14.5, 14.8, 15],
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


def fetch_b3_stock_price_brl(ticker: str) -> float:
    """Fetch the latest BRL price for a B3 stock using brapi.dev.

    Raises ConnectionError if the API request fails and ValueError if the ticker
    is not found or the response is malformed.
    """
    url = f"https://brapi.dev/api/quote/{ticker}?range=1d&interval=1d&fundamental=false&dividends=false"
    try:
        response = requests.get(url, timeout=10)
        response.raise_for_status()
        data = response.json()
    except requests.RequestException as exc:
        raise ConnectionError("API de ações indisponível") from exc

    results = data.get("results") or data.get("stocks")
    if not results:
        raise ValueError("Ticker inválido")
    price = results[0].get("regularMarketPrice")
    if price is None:
        raise ValueError("Preço não disponível")
    return float(price)


def get_b3_stock_price_brl(ticker: str) -> float:
    """Return the latest BRL price for a B3 stock.

    Attempts to fetch live data and falls back to the offline table on failure.
    """
    try:
        return fetch_b3_stock_price_brl(ticker)
    except Exception:
        return get_b3_stock_info(ticker)["price_brl"]


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


def get_currency_price_brl(code: str) -> float:
    """Return the latest price of a currency in BRL.

    Falls back to the last offline value if the API is unavailable.
    """
    if code == "BRL":
        return 1.0
    try:
        return convert(1.0, code, "BRL")
    except Exception:
        hist = CURRENCY_HISTORY_BRL.get(code)
        if not hist:
            raise
        return hist[-1]


def get_all_currency_prices_brl() -> dict:
    """Return current BRL prices for all known currencies."""
    return {c: get_currency_price_brl(c) for c in CURRENCIES.keys()}


def gather_monitor_data() -> dict:
    """Return data used by the monitoring interfaces."""
    return {
        "currencies": get_all_currency_prices_brl(),
        "stocks": {t: get_b3_stock_price_brl(t) for t in B3_STOCKS.keys()},
    }


