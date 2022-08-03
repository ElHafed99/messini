import 'package:aftersad_store/main.dart';
import 'package:aftersad_store/models/order_item_model.dart';
import 'package:aftersad_store/models/product_model.dart';
import 'package:aftersad_store/utils/app_const.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:helpers/helpers.dart';
import 'package:ionicons/ionicons.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class ProductDetails extends StatefulWidget {
  final ProductModel product;

  const ProductDetails({Key? key, required this.product}) : super(key: key);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: ListView(
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                children: [
                  Stack(
                    children: [
                      Hero(
                        tag: "product${widget.product.id}",
                        child: CachedNetworkImage(
                          imageUrl: widget.product.image,
                          placeholder: (context, url) =>
                              Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) =>
                              Icon(Ionicons.image, size: 48),
                          width: Get.width,
                          height: Get.height / 3,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: InkWell(
                          onTap: () => Get.back(),
                          child: Container(
                            margin: const Margin.all(8),
                            padding: const Margin.all(8),
                            decoration: BoxDecoration(
                                color: Colors.blueGrey.withOpacity(0.7),
                                borderRadius: EdgeRadius.all(10)),
                            child: const Icon(
                              Ionicons.chevron_back,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  ListTile(
                    title: Headline6(
                      widget.product.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const Margin.horizontal(10),
                    child: Wrap(
                      spacing: 10,
                      children: [
                        Chip(
                            avatar: const Icon(Ionicons.pricetag_outline),
                            label: Text(
                                "${widget.product.price} ${AppConst.appCurrency}")),
                        Chip(
                            avatar: const Icon(Ionicons.server_outline),
                            label: Text(
                                "${widget.product.unitSize} ${widget.product.unit}")),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const Margin.all(10.0),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      title: Headline6(
                        "description".tr(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: BodyText1(
                          widget.product.description,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              tileColor: Colors.blue.shade700,
              onTap: () {
                List<OrderItemModel> _tmpList = cartItemsNotifier.value;
                OrderItemModel? cartProduct = _tmpList.firstWhereOrNull(
                    (element) => element.product.id == widget.product.id);

                if (cartProduct != null) {
                  cartProduct.qty++;
                } else {
                  _tmpList.add(OrderItemModel(product: widget.product, qty: 1));
                }
                cartItemsNotifier.value = _tmpList;
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("itemAdded".tr()),
                  action: SnackBarAction(
                      label: "viewCart".tr(),
                      onPressed: () {
                        Get.offAll(() => const MainPage(
                              selectedIndex: 2,
                            ));
                      }),
                  shape:
                      RoundedRectangleBorder(borderRadius: EdgeRadius.all(10)),
                  behavior: SnackBarBehavior.floating,
                ));
              },
              title: Headline6(
                "addToCart".tr(),
                style: TextStyle(color: Colors.white),
              ),
              leading: const Icon(Ionicons.cart_outline, color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
