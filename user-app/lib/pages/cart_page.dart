import 'package:aftersad_store/main.dart';
import 'package:aftersad_store/models/order_item_model.dart';
import 'package:aftersad_store/pages/checkout_page.dart';
import 'package:aftersad_store/utils/app_const.dart';
import 'package:aftersad_store/utils/app_themes.dart';
import 'package:aftersad_store/utils/app_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:helpers/helpers.dart';
import 'package:ionicons/ionicons.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final List<OrderItemModel> _tmpList = cartItemsNotifier.value;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Headline6("cart".tr(),
            style: TextStyle(
                color: AppThemes.lightGreyColor, fontWeight: FontWeight.bold)),
      ),
      body: ValueListenableBuilder(
          valueListenable: cartItemsNotifier,
          builder: (context, items, _) {
            List<OrderItemModel> cartItems = items as List<OrderItemModel>;

            double totalPrice = 0;
            for (var element in cartItems) {
              totalPrice += element.product.price * element.qty;
            }

            return cartItems.isNotEmpty
                ? Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                            itemCount: cartItems.length,
                            itemBuilder: (context, index) {
                              OrderItemModel orderItem = cartItems[index];
                              return Card(
                                elevation: 0.0,
                                //color: Colors.blueGrey.shade50,
                                clipBehavior: Clip.antiAlias,
                                shape: RoundedRectangleBorder(
                                    borderRadius: EdgeRadius.all(8)),
                                //color: Colors.black,
                                child: Row(
                                  children: [
                                    Hero(
                                      tag: "product${orderItem.product.id}",
                                      child: Padding(
                                        padding: const Margin.all(8.0),
                                        child: ClipRRect(
                                          borderRadius: EdgeRadius.all(10),
                                          child: /* Image.network(
                                              orderItem.product.image,
                                              fit: BoxFit.cover,
                                              width: Get.size.width / 4,
                                              height: Get.size.width / 4,
                                            )*/
                                              CachedNetworkImage(
                                            imageUrl: orderItem.product.image,
                                            placeholder: (context, url) => Center(
                                                child:
                                                    CircularProgressIndicator()),
                                            errorWidget: (context, url,
                                                    error) =>
                                                Icon(Ionicons.image, size: 48),
                                            width: Get.width / 4,
                                            height: Get.width / 4,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const Margin.all(8.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: BodyText1(
                                                    orderItem.product.title,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    maxLines: 2,
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      _tmpList.removeWhere(
                                                          (element) =>
                                                              element
                                                                  .product.id ==
                                                              orderItem
                                                                  .product.id);
                                                      cartItemsNotifier.value =
                                                          _tmpList;
                                                    });
                                                  },
                                                  child: const Icon(
                                                    Ionicons.close_circle,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            BodyText2(
                                              "${(orderItem.product.unitSize * orderItem.qty).toStringAsFixed(2)} ${orderItem.product.unit}",
                                              maxLines: 1,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const Divider(),
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Expanded(
                                                    child: BodyText2(
                                                  "${(orderItem.product.price * orderItem.qty).toStringAsFixed(2)} ${AppConst.appCurrency}",
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                      color:
                                                          context.color.primary,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )),
                                                InkWell(
                                                  onTap: () {
                                                    OrderItemModel cartProduct =
                                                        _tmpList.firstWhere(
                                                            (element) =>
                                                                element.product
                                                                    .id ==
                                                                orderItem
                                                                    .product
                                                                    .id);

                                                    if (cartProduct.qty > 1) {
                                                      setState(() {
                                                        cartProduct.qty--;
                                                        cartItemsNotifier
                                                            .value = _tmpList;
                                                      });
                                                    }
                                                  },
                                                  child: const Icon(
                                                    Ionicons.remove_circle,
                                                    color: Colors.orange,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const Margin.horizontal(
                                                          8),
                                                  child: BodyText2(
                                                    "${orderItem.qty}",
                                                    maxLines: 1,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    OrderItemModel cartProduct =
                                                        _tmpList.firstWhere(
                                                            (element) =>
                                                                element.product
                                                                    .id ==
                                                                orderItem
                                                                    .product
                                                                    .id);

                                                    setState(() {
                                                      cartProduct.qty++;
                                                      cartItemsNotifier.value =
                                                          _tmpList;
                                                    });
                                                  },
                                                  child: const Icon(
                                                    Ionicons.add_circle,
                                                    color: Colors.green,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                      ),
                      Padding(
                        padding: const Margin.all(8.0),
                        child: ListTile(
                            //tileColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: EdgeRadius.all(10)),
                            title: Headline6(
                              "totalPrice".tr(),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            trailing: Headline6(
                              "$totalPrice ${AppConst.appCurrency}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: context.color.primary),
                            )),
                      ),
                      Padding(
                        padding: const Margin.all(8.0),
                        child: ListTile(
                          onTap: () {
                            Get.to(() => CheckoutPage(
                                  orderItems: cartItems,
                                  totalPrice: totalPrice,
                                ));
                          },
                          tileColor: context.color.primary,
                          shape: RoundedRectangleBorder(
                              borderRadius: EdgeRadius.all(10)),
                          title: Center(
                            child: Headline6(
                              "checkout".tr(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                : AppWidgets().EmptyDataWidget(
                    title: "cartNoItem".tr(), icon: Ionicons.cart_outline);
          }),
    );
  }
}
