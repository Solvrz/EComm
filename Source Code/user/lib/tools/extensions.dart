extension StringExtension on String {
  String capitalize() {
    return length > 0 ? this[0].toUpperCase() + substring(1) : "";
  }

  int toInt() {
    return int.parse(this);
  }

  double toDouble() {
    return double.parse(this);
  }

  DateTime toDate() {
    return DateTime.fromMicrosecondsSinceEpoch(
      toString().split("(")[1].split("=")[1].split(",")[0].toInt() * 1000000 +
          toString().split("(")[1].split("=")[2].split(")")[0].toInt() ~/ 1000,
    );
  }
}
