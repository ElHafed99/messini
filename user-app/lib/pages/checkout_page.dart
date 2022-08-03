import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:aftersad_store/main.dart';
import 'package:aftersad_store/models/order_item_model.dart';
import 'package:aftersad_store/models/order_model.dart';
import 'package:aftersad_store/utils/app_const.dart';
import 'package:aftersad_store/utils/app_helper.dart';
import 'package:aftersad_store/utils/app_themes.dart';
import 'package:aftersad_store/utils/app_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart' hide Trans;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:helpers/helpers.dart';
import 'package:ionicons/ionicons.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class CheckoutPage extends StatefulWidget {
  final List<OrderItemModel> orderItems;
  final double totalPrice;

  const CheckoutPage(
      {Key? key, required this.orderItems, required this.totalPrice})
      : super(key: key);

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String payment = "Cash on delivery";
  String userAddress = "";

  LatLng? currentLatLng;
  bool isMapLoading = true;

  final Completer<GoogleMapController> _controller = Completer();

  getUserLocation() async {
    //await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      currentLatLng = LatLng(position.latitude, position.longitude);
    });
    selectedPos = Marker(
      markerId: const MarkerId("selectedPos"),
      position: currentLatLng!,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );
    getAddressData();
    setState(() {
      isMapLoading = false;
    });
  }

  getAddressData() async {
    GeoData data = await Geocoder2.getDataFromCoordinates(
        latitude: currentLatLng!.latitude,
        longitude: currentLatLng!.longitude,
        googleMapApiKey: AppConst.googleMapApiKey);

    setState(() {
      userAddress = data.address;
    });
  }

  @override
  void initState() {
    getUserLocation();
    super.initState();
  }

  late Marker selectedPos;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //  backgroundColor: Colors.white,
        title: Headline6("checkout".tr(),
            style: TextStyle(
                color: AppThemes.lightGreyColor, fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const Margin.all(8),
        children: [
          Card(
            shape: RoundedRectangleBorder(borderRadius: EdgeRadius.all(10)),
            elevation: 0.0,
            child: Padding(
              padding: const Margin.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    contentPadding: Margin.zero,
                    visualDensity:
                        const VisualDensity(horizontal: 0, vertical: -4),
                    title: Headline6("items".tr(),
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    trailing: Headline6("${widget.orderItems.length}",
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  GridView.builder(
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 6),
                      itemCount: widget.orderItems.length,
                      itemBuilder: (context, index) {
                        OrderItemModel orderItem = widget.orderItems[index];
                        return Stack(
                          fit: StackFit.expand,
                          children: [
                            Tooltip(
                              message: orderItem.product.title,
                              child: Card(
                                color: context.color.scaffold,
                                shape: RoundedRectangleBorder(
                                    borderRadius: EdgeRadius.all(10)),
                                elevation: 0.0,
                                clipBehavior: Clip.antiAlias,
                                child: CachedNetworkImage(
                                  imageUrl: orderItem.product.image,
                                  placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator()),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Ionicons.image, size: 48),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: CircleAvatar(
                                radius: 10,
                                backgroundColor: Colors.blueGrey,
                                child: BodyText1(
                                  "${orderItem.qty}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                ],
              ),
            ),
          ),
          Card(
            elevation: 0.0,
            shape: RoundedRectangleBorder(borderRadius: EdgeRadius.all(10)),
            child: Column(
              children: [
                ListTile(
                  title: Subtitle1("selectLocation".tr(),
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Headline6("$userAddress"),
                ),
                Container(
                  height: Get.width * .7,
                  padding: const EdgeInsets.all(8),
                  child: currentLatLng == null
                      ? const Center(child: CircularProgressIndicator())
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: GoogleMap(
                            gestureRecognizers: <
                                Factory<OneSequenceGestureRecognizer>>{
                              Factory<OneSequenceGestureRecognizer>(
                                () => EagerGestureRecognizer(),
                              ),
                            },
                            onTap: (latlng) {
                              setState(() {
                                currentLatLng = latlng;
                              });

                              setState(() {
                                selectedPos = Marker(
                                  markerId: const MarkerId("selectedPos"),
                                  position: latlng,
                                  icon: BitmapDescriptor.defaultMarkerWithHue(
                                      BitmapDescriptor.hueRed),
                                );
                              });
                              getAddressData();
                            },
                            myLocationButtonEnabled: true,
                            mapToolbarEnabled: false,
                            myLocationEnabled: true,
                            mapType: MapType.hybrid,
                            zoomControlsEnabled: false,
                            initialCameraPosition: CameraPosition(
                              target: currentLatLng!,
                              zoom: 17,
                            ),
                            onMapCreated: (GoogleMapController controller) {
                              _controller.complete(controller);
                            },
                            markers: [selectedPos].toList().toSet(),
                          ),
                        ),
                ),
              ],
            ),
          ),
          Card(
            shape: RoundedRectangleBorder(borderRadius: EdgeRadius.all(10)),
            elevation: 0.0,
            child: Padding(
              padding: const Margin.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    contentPadding: Margin.zero,
                    visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                    title: Headline6("paymentMethode".tr(),
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  RadioListTile(
                    title: Text("cashOnDelivery".tr(),
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    value: "Cash on delivery",
                    groupValue: payment,
                    secondary: const Icon(Ionicons.cube),
                    onChanged: (value) {
                      setState(() {
                        payment = "$value";
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          Card(
            shape: RoundedRectangleBorder(borderRadius: EdgeRadius.all(10)),
            elevation: 0.0,
            child: Padding(
              padding: const Margin.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    visualDensity:
                        const VisualDensity(horizontal: 0, vertical: -4),
                    title: Text("subtotal".tr(),
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    trailing: Text(
                        "${widget.totalPrice} ${AppConst.appCurrency}",
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  ListTile(
                    visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                    title: Text("deliveryFee".tr(),
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    trailing: Text("${AppConst.fee} ${AppConst.appCurrency}",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  ListTile(
                    visualDensity:
                        const VisualDensity(horizontal: 0, vertical: -4),
                    title: Text("total".tr(),
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    trailing: Text(
                        "${widget.totalPrice + AppConst.fee} ${AppConst.appCurrency}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: context.color.primary)),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const Margin.all(8.0),
            child: ListTile(
              onTap: () {
                /*print("${List.generate(widget.orderItems.length, (index) => json.encode(widget.orderItems[index].toJson())).toList()}");*/
                AppWidgets().MyDialog(
                    context: context,
                    title: "loading",
                    background: Colors.blue,
                    asset:
                        const CircularProgressIndicator(color: Colors.white));
                AppData()
                    .addOrder(
                        orderModel: OrderModel(
                            orderItems:
                                "${List.generate(widget.orderItems.length, (index) => json.encode(widget.orderItems[index].toJson())).toList()}",
                            userLocation: userAddress,
                            userPhone:
                                FirebaseAuth.instance.currentUser!.phoneNumber!,
                            userLatLng:
                                "${currentLatLng!.latitude},${currentLatLng!.longitude}",
                            passcode: Random()
                                .nextInt(9999)
                                .toString()
                                .padLeft(4, '0'),
                            userUid: FirebaseAuth.instance.currentUser!.uid,
                            statusId: 0))
                    .then((value) {
                  cartItemsNotifier = ValueNotifier(<OrderItemModel>[]);
                  Get.back();
                  print(value);
                  if (value['type'] == "success") {
                    AppWidgets().MyDialog(
                        context: context,
                        asset: const Icon(
                          Ionicons.checkmark_circle,
                          size: 80,
                          color: Colors.white,
                        ),
                        background: context.color.primary,
                        title: "orderCreated".tr(),
                        confirm: ElevatedButton(
                            onPressed: () {
                              Get.offAll(() => const MainPage(
                                    selectedIndex: 3,
                                  ));
                            },
                            child: Text("ok".tr())));
                  } else {
                    AppWidgets().MyDialog(
                        context: context,
                        asset: const Icon(
                          Ionicons.close_circle,
                          size: 80,
                          color: Colors.white,
                        ),
                        background: const Color(0xffDF2E2E),
                        title: "orderNotCreated".tr(),
                        confirm: ElevatedButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: Text("back".tr())));
                  }
                });
              },
              tileColor: context.color.primary,
              shape: RoundedRectangleBorder(borderRadius: EdgeRadius.all(10)),
              title: Center(
                child: Headline6(
                  "checkout".tr(),
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
