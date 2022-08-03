class UserModel {
  UserModel({required this.uid, required this.phone});
  final String uid;
  final String phone;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['uid'] = uid;
    _data['phone'] = phone;
    return _data;
  }
}
