class NewAssignTestData {
  String title, maxExec, timeStart, timeEnd, token, uri, id;
  bool isSearch = false;
  List<String> listUri = [];
  NewAssignTestData copy() {
    final clone = NewAssignTestData();
    clone.title = title;
    clone.maxExec = maxExec;
    clone.timeStart = timeStart;
    clone.timeEnd = timeEnd;
    clone.uri = uri;
    clone.token = token;
    clone.listUri = listUri;
    clone.id = id;
    clone.isSearch = isSearch;
    return clone;
  }
}
