class OrderModel {
  OrderModel({
    required this.orderItems,
    required this.userLocation,
    required this.userLatLng,
    required this.userPhone,
    required this.userUid,
    required this.statusId,
    required this.passcode,
    this.id,
    this.driverId,
    this.createdAt,
  });

  final int? id;
  final String orderItems;
  final String userLocation;
  final String userLatLng;
  final String userPhone;
  final String userUid;
  final int statusId;
  final String passcode;
  final int? driverId;
  final String? createdAt;

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: int.parse(json['id'].toString()),
      orderItems: json['orderItems'],
      userLocation: json['userLocation'],
      userLatLng: json['userLatLng'],
      userPhone: json['userPhone'],
      userUid: json['userUid'],
      statusId: int.parse(
        json['statusId'].toString(),
      ),
      passcode: json['passcode'],
      driverId: int.parse(
        json['driverId'].toString(),
      ),
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id ?? '';
    _data['orderItems'] = orderItems;
    _data['userLocation'] = userLocation;
    _data['userLatLng'] = userLatLng;
    _data['userPhone'] = userPhone;
    _data['userUid'] = userUid;
    _data['statusId'] = statusId;
    _data['passcode'] = passcode;
    _data['driverId'] = driverId;
    _data['createdAt'] = createdAt;

    return _data;
  }
}
