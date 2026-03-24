String formatNumber(double? value) {
  if (value == null) {
    return '-';
  }
  if (value % 1 == 0) {
    return '${value.toInt()}';
  }
  return '$value';
}
