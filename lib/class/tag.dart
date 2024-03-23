class Tag{

  int idTag;
  String name;

  Tag(this.idTag, this.name);

  Map<String, dynamic> toJson() {
    return {
      'idTag': idTag,
      'name': name,
    };
  }

  factory Tag.fromMap(Map<String, dynamic> map) {
    return Tag(
        map['id_tag'],
        map['name']
    );
  }
}