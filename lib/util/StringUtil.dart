extension StringExtension on String {
  bool isNumeric() {
    if (isEmpty) {
      return false;
    }
    return double.tryParse(this) != null;
  }

  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }

}

