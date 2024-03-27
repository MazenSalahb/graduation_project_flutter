class CategoryModel {
  int? id;
  String? name;
  String? color;
  String? createdAt;
  String? updatedAt;

  CategoryModel(
      {this.id, this.name, this.color, this.createdAt, this.updatedAt});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    color = json['color'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}
