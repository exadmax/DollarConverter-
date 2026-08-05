/// Calculates the investment needed for a desired weekly profit.
double investmentForWeeklyProfit(double target, double weeklyReturnPercent) {
  if (weeklyReturnPercent <= 0) {
    throw ArgumentError('Rendimento deve ser maior que zero.');
  }
  return target / (weeklyReturnPercent / 100);
}
