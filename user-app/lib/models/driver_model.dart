class DriverModel {
  DriverModel({
    this.id,
    required this.phone,
    required this.name,
    this.available,
  });
  final int? id;
  final String phone;
  final String name;
  final int? available;

  factory DriverModel.fromJson(Map<String, dynamic> json) {
    return DriverModel(
      id: int.parse(json['id'].toString()),
      phone: json['phone'],
      name: json['name'],
      available: int.parse(json['available'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['phone'] = phone;
    _data['name'] = name;
    _data['available'] = available;
    return _data;
  }
}
