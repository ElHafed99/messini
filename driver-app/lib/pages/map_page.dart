import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart' hide Trans;
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:helpers/helpers.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:ionicons/ionicons.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:pinput/pinput.dart';
import 'package:store_driver/main.dart';
import 'package:store_driver/models/order_item_model.dart';
import 'package:store_driver/models/order_model.dart';
import 'package:store_driver/utils/app_const.dart';
import 'package:store_driver/utils/app_helper.dart';
import 'package:store_driver/utils/app_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class MapPage extends StatefulWidget {
  final OrderModel order;

  const MapPage({Key? key, required this.order}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  bool isLoading = true;

  late LatLng dest_location = LatLng(
      double.parse(widget.order.userLatLng.split(',').first),
      double.parse(widget.order.userLatLng.split(',').last));

  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  late GoogleMapController newGoogleMapController;
  late Position currentPosition;
  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  double totalPrice = 0;

  void locatePosition() async {
    //await Geolocator.requestPermission();
    getOrderTotalPrice();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;
    setState(() {
      isLoading = false;
    });
  }

  CameraPosition _UserLocation() {
    return CameraPosition(
      target: LatLng(currentPosition.latitude, currentPosition.longitude),
      zoom: 17,
    );
  }

  getOrderTotalPrice() {
    List orderItemList =
        json.decode(HtmlUnescape().convert(widget.order.orderItems));

    for (var element in orderItemList) {
      setState(() {
        totalPrice += OrderItemModel.fromJson(element).product.price *
            OrderItemModel.fromJson(element).qty;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    locatePosition();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: isLoading
            ? Container()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: GoogleMap(
                      mapType: MapType.normal,
                      myLocationButtonEnabled: true,
                      initialCameraPosition: _UserLocation(),
                      polylines: Set<Polyline>.of(polylines.values),
                      markers: Set<Marker>.of(markers.values),
                      myLocationEnabled: true,
                      zoomGesturesEnabled: true,
                      onMapCreated: (GoogleMapController controller) {
                        _controllerGoogleMap.complete(controller);
                        newGoogleMapController = controller;
                        _getPolyline();

                        setState(() {});
                      },
                    ),
                  ),
                  Card(
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Headline5(
                            "${totalPrice + AppConst.fee} ${AppConst.appCurrency}",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          ListTile(
                            title: Text(
                              "address".tr(),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text("${widget.order.userLocation}"),
                          ),
                          ListTile(
                            onTap: () {
                              showModalBottomSheet<void>(
                                context: context,
                                isScrollControlled: true,
                                shape: RoundedRectangleBorder(
                                    borderRadius: EdgeRadius.top(16)),
                                builder: (BuildContext context) {
                                  return confirmOrder(widget.order);
                                },
                              );
                            },
                            title: Text(
                              "confirmOrder".tr(),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle:
                                Text("${'order'.tr()} #${widget.order.id}"),
                            trailing: Icon(translator.activeLanguageCode == 'ar'
                                ? Ionicons.chevron_back
                                : Ionicons.chevron_forward),
                          ),
                          ListTile(
                            onTap: () async {
                              if (!await launchUrl(
                                  Uri.parse('tel:${widget.order.userPhone}')))
                                throw 'Could not launch';
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: EdgeRadius.all(10)),
                            tileColor: BuildColor(context).primary,
                            title: Text(
                              "callUser".tr(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            subtitle: Text(
                              "${widget.order.userPhone}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            trailing: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: EdgeRadius.all(10)),
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(Ionicons.call,
                                    color: BuildColor(context).primary),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker = Marker(
      markerId: markerId,
      icon: descriptor,
      position: position,
    );
    markers[markerId] = marker;
  }

  _addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id,
        points: polylineCoordinates,
        width: 4,
        color: Colors.red);
    polylines[id] = polyline;
    setState(() {});
  }

  void _getPolyline() async {
    _addMarker(
      LatLng(dest_location.latitude, dest_location.longitude),
      "destination",
      BitmapDescriptor.defaultMarker,
    );

    List<LatLng> polylineCoordinates = [];

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      AppConst.googleMapApiKey,
      PointLatLng(currentPosition.latitude, currentPosition.longitude),
      PointLatLng(dest_location.latitude, dest_location.longitude),
      travelMode: TravelMode.driving,
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }
    _addPolyLine(polylineCoordinates);
    setState(() {
      isLoading = false;
    });
  }

  bool enablePasscodeButton = false;
  String passcode = '';
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();

  confirmOrder(OrderModel order) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: 16, vertical: MediaQuery.of(context).size.width / 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Headline5(
              "orderPasscode".tr(),
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Headline6(
              "orderPasscodeDescription".tr(),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 32,
            ),
            Pinput(
              length: 4,
              focusNode: _pinPutFocusNode,
              controller: _pinPutController,
              pinAnimationType: PinAnimationType.fade,
              onCompleted: (pin) async {
                setState(() {
                  passcode = pin;
                  enablePasscodeButton = true;
                });
              },
            ),
            enablePasscodeButton
                ? const SizedBox(
                    height: 32,
                  )
                : const SizedBox(),
            enablePasscodeButton
                ? ListTile(
                    onTap: () async {
                      AppWidgets().MyDialog(
                          context: context,
                          title: "loading".tr(),
                          background: Colors.blue,
                          asset: const CircularProgressIndicator(
                              color: Colors.white));
                      if (passcode == order.passcode) {
                        print("order id : ${order.id}");
                        print(
                            "driver id : ${GetStorage().read('driverData')['id']}");
                        await AppData()
                            .confirmOrder(
                                orderId: "${order.id}",
                                driverId:
                                    "${GetStorage().read('driverData')['id']}")
                            .then((value) {
                          Get.back();
                          if (value['type'] == "success") {
                            AppWidgets().MyDialog(
                                context: context,
                                title: "success".tr(),
                                background: context.color.primary,
                                asset: const Icon(
                                  Ionicons.checkmark_circle,
                                  size: 80,
                                  color: Colors.white,
                                ),
                                confirm: TextButton(
                                    onPressed: () {
                                      Get.offAll(() => MainPage());
                                    },
                                    child: Text("ok".tr())));
                          } else {
                            AppWidgets().MyDialog(
                                context: context,
                                title: "error".tr(),
                                subtitle: "sww".tr(),
                                background: Colors.red,
                                asset: const Icon(
                                  Ionicons.close_circle,
                                  size: 80,
                                  color: Colors.white,
                                ),
                                confirm: TextButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    child: Text("ok".tr())));
                          }
                        });
                      } else {
                        Get.back();
                        AppWidgets().MyDialog(
                            context: context,
                            title: "error".tr(),
                            subtitle: "passcodeNotCorrect".tr(),
                            background: Colors.red,
                            asset: const Icon(
                              Ionicons.close_circle,
                              size: 80,
                              color: Colors.white,
                            ),
                            confirm: TextButton(
                                onPressed: () {
                                  Get.back();
                                },
                                child: Text("ok".tr())));
                      }
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: EdgeRadius.all(10)),
                    tileColor: BuildColor(context).primary,
                    title: Text(
                      "checkPasscode".tr(),
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : const SizedBox(),
            enablePasscodeButton
                ? const SizedBox(
                    height: 32,
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
