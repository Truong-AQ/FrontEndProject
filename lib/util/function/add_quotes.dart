Map<String, dynamic> addQuotes(
    Map<String, dynamic> input, Map<String, dynamic> output) {
  for (var e in input.entries) {
    if (e.value is String) {
      output['"${e.key}"'] = '"${e.value}"';
    } else if (e.value is Map) {
      output['"${e.key}"'] = addQuotes(e.value, {});
    } else if (e.value is List) {
      if (e.value.length > 0)
        output['"${e.key}"'] = _addQuotesForList(e.value, []);
      else output['"${e.key}"'] = [];
    } else {
      output['"${e.key}"'] = e.value;
    }
  }
  return output;
}

List _addQuotesForList(List input, List<Map<String, dynamic>> output) {
  for (var e in input) {
    output.add(addQuotes(e, {}));
  }
  return output;
}
