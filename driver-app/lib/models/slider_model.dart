class SliderModel {
  SliderModel({
    required this.title,
    required this.subtitle,
    this.image,
    this.color,
    required this.showToUser,
    this.id,
  });

  final String title;
  final String subtitle;
  final String? image;
  final String? color;
  final int? id;
  final int? showToUser;

  factory SliderModel.fromJson(Map<String, dynamic> json) {
    return SliderModel(
      title: json['title'],
      subtitle: json['subtitle'],
      image: json['image'],
      color: json['color'],
      id: int.parse(json['id'].toString()),
      showToUser: int.parse(json['showToUser'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['title'] = title;
    _data['subtitle'] = subtitle;
    _data['image'] = image;
    _data['color'] = color;
    _data['id'] = id;
    _data['showToUser'] = showToUser;
    return _data;
  }
}
