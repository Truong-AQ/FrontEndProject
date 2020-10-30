class ResponseTopic {
  List<Tree> tree;

  ResponseTopic.fromJson(Map<String, dynamic> json) {
    if (json['tree'] != null) {
      tree = new List<Tree>();
      json['tree'].forEach((v) {
        tree.add(new Tree.fromJson(v));
      });
    }
  }
}

class Tree {
  String data;
  String type;
  Attributes attributes;
  String state;
  int count;

  Tree.fromJson(Map<String, dynamic> json) {
    data = json['data'];
    type = json['type'];
    attributes = json['attributes'] != null
        ? new Attributes.fromJson(json['attributes'])
        : null;
    state = json['state'];
    count = json['count'];
  }
}

class Attributes {
  String id;
  String classAttribute;
  String dataUri;
  String dataClassUri;

  Attributes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    classAttribute = json['class'];
    dataUri = json['data-uri'];
    dataClassUri = json['data-classUri'];
  }
}
