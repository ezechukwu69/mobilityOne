extension StringExtension on String {
  String capitalizeFirstLetter() {
    return '${this[0].toUpperCase()}${this.substring(1)}';
  }

  String trimCharsAtEnd(int number) {
    return '${this.trim().substring(0, this.length - number)}';
  }

  bool isEqualIgnoreCase(String str) {
    return this.toLowerCase() == str.toLowerCase();
  }
}
