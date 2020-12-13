Map<String, dynamic> addQuotes(
    Map<String, dynamic> input, Map<String, dynamic> output) {
  for (var e in input.entries) {
    if (e.value is String) {
      output['"${e.key}"'] = '"${e.value}"';
    } else if (e.value is Map) {
      output['"${e.key}"'] = addQuotes(e.value, {});
    } else if (e.value is List) {
      for(var eInList in e.value) {

      }
    }
  }
  return output;
}
