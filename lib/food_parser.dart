class FoodParser {
  static Map<String, String> parseFoodString(String foodString) {
    final lines = foodString.trim().split('\n');
    final foodData = <String, String>{};

    for (final line in lines) {
      if (line.contains(':')) {
        final parts = line.split(':');
        if (parts.length == 2) {
          final key = parts[0].trim();
          final value = parts[1].trim();
          foodData[key] = value;
        }
      }
    }
    return foodData;
  }
}
