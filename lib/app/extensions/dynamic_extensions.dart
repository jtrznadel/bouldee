extension DynamicExtensions on dynamic {
  T toEnum<T>(Iterable<T> values) {
    return values.firstWhere(
      (type) => type.toString().split('.').last == toString(),
      orElse: () => values.first,
    );
  }
}
