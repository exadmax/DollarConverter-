// Static reference data ported from the original Python `core.py`.
// Values here are only used as offline fallback when live APIs are
// unreachable, or as seed data for the default watchlist.

class StockInfo {
  final String ticker;
  final String name;
  final double price;
  final double weeklyReturn;
  final List<double> monthly;

  const StockInfo({
    required this.ticker,
    required this.name,
    required this.price,
    required this.weeklyReturn,
    required this.monthly,
  });
}

/// Currency code -> display name (Portuguese).
const Map<String, String> currencyNames = {
  'USD': 'Dólar',
  'BRL': 'Real',
  'BTC': 'Bitcoin',
  'ETH': 'Ethereum',
  'BNB': 'BNB',
  'SUI': 'Sui',
  'PAXG': 'Pax Gold',
};

/// Illustrative offline monthly price history (in BRL), used only when
/// live data cannot be fetched.
const Map<String, List<double>> currencyHistoryBrl = {
  'USD': [5.0, 5.1, 5.2, 5.3, 5.4, 5.45],
  'BTC': [120000, 122000, 125000, 123000, 128000, 130000],
  'ETH': [9000, 9200, 9100, 9400, 9500, 9600],
  'BNB': [1500, 1520, 1550, 1540, 1580, 1600],
  'SUI': [10, 10.5, 10.8, 10.3, 10.6, 10.9],
  'PAXG': [9500, 9600, 9700, 9650, 9750, 9800],
  'BRL': [1, 1, 1, 1, 1, 1],
};

/// Default B3 tickers with illustrative offline data (in BRL), used as
/// the default watchlist and as fallback when brapi.dev is unreachable.
final Map<String, StockInfo> b3Stocks = {
  'PETR4': const StockInfo(ticker: 'PETR4', name: 'Petrobras PN', price: 37.50, weeklyReturn: 2.1, monthly: [34.0, 35.0, 36.2, 37.0, 37.5, 38.0]),
  'VALE3': const StockInfo(ticker: 'VALE3', name: 'Vale ON', price: 62.00, weeklyReturn: -1.2, monthly: [60.0, 61.0, 63.0, 62.5, 62.0, 63.5]),
  'ABEV3': const StockInfo(ticker: 'ABEV3', name: 'Ambev ON', price: 14.20, weeklyReturn: 0.8, monthly: [13.5, 13.8, 14.0, 14.1, 14.2, 14.3]),
  'KNCR11': const StockInfo(ticker: 'KNCR11', name: 'Kinea Rendimentos', price: 115.00, weeklyReturn: 0.5, monthly: [110, 111, 112, 113, 114, 115]),
  'ITUB4': const StockInfo(ticker: 'ITUB4', name: 'Itaú Unibanco PN', price: 30.00, weeklyReturn: 1.2, monthly: [27, 28, 29, 29.5, 29.8, 30]),
  'BBDC4': const StockInfo(ticker: 'BBDC4', name: 'Bradesco PN', price: 17.00, weeklyReturn: 1.1, monthly: [15.5, 16, 16.2, 16.7, 16.9, 17]),
  'BBAS3': const StockInfo(ticker: 'BBAS3', name: 'Banco do Brasil ON', price: 48.00, weeklyReturn: 1.8, monthly: [45, 46, 47, 47.5, 48, 48.5]),
  'WEGE3': const StockInfo(ticker: 'WEGE3', name: 'WEG ON', price: 37.00, weeklyReturn: 1.5, monthly: [33, 34, 35, 36, 36.5, 37]),
  'MGLU3': const StockInfo(ticker: 'MGLU3', name: 'Magazine Luiza ON', price: 3.20, weeklyReturn: 2.5, monthly: [2.5, 2.6, 2.8, 3.0, 3.1, 3.2]),
  'B3SA3': const StockInfo(ticker: 'B3SA3', name: 'B3 ON', price: 13.20, weeklyReturn: 1.0, monthly: [12, 12.3, 12.7, 12.9, 13.1, 13.2]),
  'LREN3': const StockInfo(ticker: 'LREN3', name: 'Lojas Renner ON', price: 21.00, weeklyReturn: 1.4, monthly: [19, 19.8, 20.2, 20.7, 20.9, 21]),
  'SUZB3': const StockInfo(ticker: 'SUZB3', name: 'Suzano ON', price: 55.00, weeklyReturn: 1.3, monthly: [50, 51, 52.5, 53, 54, 55]),
  'GGBR4': const StockInfo(ticker: 'GGBR4', name: 'Gerdau PN', price: 15.00, weeklyReturn: 1.2, monthly: [13.5, 14, 14.2, 14.5, 14.8, 15]),
  'USIM5': const StockInfo(ticker: 'USIM5', name: 'Usiminas PNA', price: 7.50, weeklyReturn: 1.1, monthly: [6.5, 6.8, 7, 7.2, 7.4, 7.5]),
  'CSNA3': const StockInfo(ticker: 'CSNA3', name: 'CSN ON', price: 18.00, weeklyReturn: 1.5, monthly: [16, 16.5, 17, 17.5, 17.8, 18]),
  'JBS3': const StockInfo(ticker: 'JBS3', name: 'JBS ON', price: 33.00, weeklyReturn: 1.2, monthly: [30, 30.8, 31.5, 32, 32.5, 33]),
  'LWSA3': const StockInfo(ticker: 'LWSA3', name: 'LWSA ON', price: 5.00, weeklyReturn: 1.3, monthly: [4.2, 4.4, 4.6, 4.7, 4.9, 5.0]),
  'PETZ3': const StockInfo(ticker: 'PETZ3', name: 'Petz ON', price: 6.30, weeklyReturn: 0.9, monthly: [5.5, 5.7, 5.8, 6.0, 6.2, 6.3]),
  'YDUQ3': const StockInfo(ticker: 'YDUQ3', name: 'Yduqs ON', price: 18.00, weeklyReturn: 1.7, monthly: [16, 16.5, 17, 17.5, 17.8, 18]),
  'SLCE3': const StockInfo(ticker: 'SLCE3', name: 'SLC Agrícola ON', price: 41.00, weeklyReturn: 1.4, monthly: [37, 38, 39, 39.5, 40, 41]),
  'PRIO3': const StockInfo(ticker: 'PRIO3', name: 'PRIO ON', price: 40.00, weeklyReturn: 2.2, monthly: [34, 36, 37, 38, 39, 40]),
  'HAPV3': const StockInfo(ticker: 'HAPV3', name: 'Hapvida ON', price: 7.00, weeklyReturn: 1.6, monthly: [5.8, 6.2, 6.5, 6.8, 6.9, 7]),
  'EGIE3': const StockInfo(ticker: 'EGIE3', name: 'Engie Brasil ON', price: 43.00, weeklyReturn: 0.8, monthly: [41, 41.5, 42, 42.5, 42.8, 43]),
  'NTCO3': const StockInfo(ticker: 'NTCO3', name: 'Natura ON', price: 15.00, weeklyReturn: 1.5, monthly: [13, 13.5, 14, 14.5, 14.8, 15]),
};

/// Illustrative S&P 500 blue-chip stocks (price in USD), used as the
/// default watchlist source and offline fallback for the "Ações S&P
/// 500" screen — mirrors [b3Stocks] but for the American market.
final Map<String, StockInfo> spStocks = {
  'AAPL': const StockInfo(ticker: 'AAPL', name: 'Apple Inc.', price: 230.00, weeklyReturn: 1.1, monthly: [190, 200, 210, 205, 220, 230]),
  'MSFT': const StockInfo(ticker: 'MSFT', name: 'Microsoft Corp.', price: 430.00, weeklyReturn: 0.9, monthly: [370, 385, 395, 400, 415, 430]),
  'GOOGL': const StockInfo(ticker: 'GOOGL', name: 'Alphabet Inc.', price: 175.00, weeklyReturn: 1.3, monthly: [140, 150, 158, 162, 168, 175]),
  'AMZN': const StockInfo(ticker: 'AMZN', name: 'Amazon.com Inc.', price: 195.00, weeklyReturn: 1.0, monthly: [160, 168, 175, 180, 188, 195]),
  'NVDA': const StockInfo(ticker: 'NVDA', name: 'NVIDIA Corp.', price: 140.00, weeklyReturn: 2.4, monthly: [90, 100, 112, 120, 130, 140]),
  'META': const StockInfo(ticker: 'META', name: 'Meta Platforms Inc.', price: 590.00, weeklyReturn: 1.2, monthly: [480, 500, 520, 540, 565, 590]),
  'TSLA': const StockInfo(ticker: 'TSLA', name: 'Tesla Inc.', price: 250.00, weeklyReturn: -0.8, monthly: [230, 260, 245, 270, 240, 250]),
  'BRK-B': const StockInfo(ticker: 'BRK-B', name: 'Berkshire Hathaway Inc.', price: 460.00, weeklyReturn: 0.5, monthly: [420, 430, 440, 445, 452, 460]),
  'JPM': const StockInfo(ticker: 'JPM', name: 'JPMorgan Chase & Co.', price: 235.00, weeklyReturn: 0.7, monthly: [200, 210, 215, 222, 228, 235]),
  'JNJ': const StockInfo(ticker: 'JNJ', name: 'Johnson & Johnson', price: 155.00, weeklyReturn: 0.3, monthly: [148, 150, 151, 152, 154, 155]),
  'V': const StockInfo(ticker: 'V', name: 'Visa Inc.', price: 310.00, weeklyReturn: 0.8, monthly: [275, 285, 292, 298, 304, 310]),
  'PG': const StockInfo(ticker: 'PG', name: 'Procter & Gamble Co.', price: 170.00, weeklyReturn: 0.2, monthly: [163, 165, 166, 167, 169, 170]),
  'UNH': const StockInfo(ticker: 'UNH', name: 'UnitedHealth Group Inc.', price: 560.00, weeklyReturn: 0.6, monthly: [520, 530, 540, 545, 552, 560]),
  'HD': const StockInfo(ticker: 'HD', name: 'Home Depot Inc.', price: 400.00, weeklyReturn: 0.5, monthly: [370, 378, 385, 390, 395, 400]),
  'MA': const StockInfo(ticker: 'MA', name: 'Mastercard Inc.', price: 500.00, weeklyReturn: 0.9, monthly: [450, 462, 472, 480, 490, 500]),
};

/// B3 market indices shown alongside the currency/stock watchlist.
/// brapi.dev requires an authentication token to query indices (unlike
/// plain stock tickers), and this app has no backend to hold one
/// securely, so these always fall back to an illustrative offline
/// value when the live fetch fails without an API key.
const Map<String, String> indexLabels = {
  '^BVSP': 'Índice Ibovespa',
  'IFIX': 'Índice IFIX',
  '^GSPC': 'S&P 500',
};

const Map<String, double> indexFallbackPoints = {
  '^BVSP': 136000,
  'IFIX': 3400,
  '^GSPC': 5600,
};

/// Illustrative offline monthly point history for the market indices,
/// used by the "Valorização" (appreciation) screen — same spirit as
/// [currencyHistoryBrl] and each [StockInfo.monthly].
const Map<String, List<double>> indexHistoryPoints = {
  '^BVSP': [120000, 125000, 130000, 128000, 133000, 136000],
  'IFIX': [3100, 3150, 3200, 3250, 3300, 3400],
  '^GSPC': [5100, 5200, 5300, 5250, 5450, 5600],
};

/// Percentage change between consecutive entries of a history list.
List<double> monthlyAppreciation(List<double> history) {
  final result = <double>[];
  for (var i = 1; i < history.length; i++) {
    result.add((history[i] - history[i - 1]) / history[i - 1] * 100);
  }
  return result;
}
