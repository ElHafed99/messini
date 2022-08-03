import 'package:aftersad_store/main.dart';
import 'package:aftersad_store/models/order_item_model.dart';
import 'package:aftersad_store/models/product_model.dart';
import 'package:aftersad_store/pages/product_details.dart';
import 'package:aftersad_store/utils/app_const.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:helpers/helpers.dart';
import 'package:ionicons/ionicons.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class ProductGridItem extends StatefulWidget {
  final ProductModel product;
  const ProductGridItem({Key? key, required this.product}) : super(key: key);

  @override
  _ProductGridItemState createState() => _ProductGridItemState();
}

class _ProductGridItemState extends State<ProductGridItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(() => ProductDetails(product: widget.product));
      },
      child: Card(
        elevation: 0.0,
        //color: Colors.blueGrey.shade50,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: EdgeRadius.all(10)),
        //color: Colors.black,
        child: Column(
          children: [
            Expanded(
                child: Hero(
              tag: "product${widget.product.id}",
              child: Padding(
                padding: const Margin.all(8.0),
                child: ClipRRect(
                  borderRadius: EdgeRadius.all(8),
                  child: /*Image.network(
                    widget.product.image,
                    fit: BoxFit.cover,
                    width: Get.size.width,
                  )*/
                      CachedNetworkImage(
                    imageUrl: widget.product.image,
                    placeholder: (context, url) =>
                        Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        Icon(Ionicons.image, size: 48),
                    width: Get.size.width,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            )),
            const SizedBox(
              height: 4,
            ),
            Column(
              children: [
                BodyText1(
                  widget.product.title,
                  maxLines: 1,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                BodyText2(
                  "${widget.product.price} ${AppConst.appCurrency}",
                  maxLines: 1,
                  style: TextStyle(
                      color: context.color.primary,
                      fontWeight: FontWeight.bold),
                ),
                BodyText2(
                  "${widget.product.unitSize} ${widget.product.unit}",
                  maxLines: 1,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    List<OrderItemModel> _tmpList = cartItemsNotifier.value;
                    OrderItemModel? cartProduct = _tmpList.firstWhereOrNull(
                        (element) => element.product.id == widget.product.id);

                    if (cartProduct != null) {
                      cartProduct.qty++;
                    } else {
                      _tmpList
                          .add(OrderItemModel(product: widget.product, qty: 1));
                    }
                    cartItemsNotifier.value = _tmpList;
                  },
                  label: Text("add".tr()),
                  icon: const Icon(Ionicons.bag_add_outline),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
