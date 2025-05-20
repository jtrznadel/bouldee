extension ObjectExtensions on Object? {
  int toInt() {
    if (this is int) {
      return this! as int;
    } else if (this is double) {
      return (this! as double).toInt();
    } else if (this is String) {
      return int.tryParse(this! as String) ?? 0;
    }
    return 0;
  }

  double toDouble() {
    if (this is double) {
      return this! as double;
    } else if (this is int) {
      return (this! as int).toDouble();
    } else if (this is String) {
      return double.tryParse(this! as String) ?? 0.0;
    }
    return 0;
  }
}
