class CategoryModel {
  CategoryModel({
    required this.title,
    required this.image,
    this.id,
    required this.showToUser,
  });

  final String title;
  final String image;
  final int showToUser;
  final int? id;

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
        title: json['title'],
        image: json['image'],
        id: int.parse(json['id'].toString()),
        showToUser: int.parse(json['showToUser'].toString()));
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['title'] = title;
    _data['image'] = image;
    _data['id'] = id;
    _data['showToUser'] = showToUser;
    return _data;
  }
}
