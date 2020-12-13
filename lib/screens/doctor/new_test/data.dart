class NewTestData {
  String name, uri, id, token;
  NewTestData copy() {
    final clone = NewTestData();
    clone.name = name;
    clone.uri = uri;
    clone.id = id;
    clone.token = token;
    return clone;
  }
}
