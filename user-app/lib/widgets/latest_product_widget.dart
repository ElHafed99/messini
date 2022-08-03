import 'package:aftersad_store/models/product_model.dart';
import 'package:aftersad_store/utils/app_helper.dart';
import 'package:aftersad_store/widgets/product_grid_item.dart';
import 'package:aftersad_store/widgets/product_list_item.dart';
import 'package:flutter/material.dart';
import 'package:helpers/helpers.dart';
import 'package:ionicons/ionicons.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class LatestProductWidget extends StatefulWidget {
  final bool productViewGrid;

  const LatestProductWidget({Key? key, required this.productViewGrid})
      : super(key: key);

  @override
  _LatestProductWidgetState createState() => _LatestProductWidgetState();
}

class _LatestProductWidgetState extends State<LatestProductWidget> {
  late Future<List<ProductModel>> futureProductList;

  @override
  void initState() {
    futureProductList = AppData().getLatestProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ProductModel>>(
      future: futureProductList,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return widget.productViewGrid
              ? GridView.builder(
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemCount: snapshot.data!.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, childAspectRatio: 0.8),
                  itemBuilder: (context, index) {
                    ProductModel product = snapshot.data![index];
                    return ProductGridItem(product: product);
                  })
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    ProductModel product = snapshot.data![index];
                    return ProductListItem(product: product);
                  });
        } else if (snapshot.hasError) {
          return Card(
            elevation: 0.0,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Ionicons.planet_outline,
                      size: 50,
                    ),
                    Subtitle1(
                      "sww".tr(),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
          );
        }
        return GridView.builder(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            itemCount: 3,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, childAspectRatio: 0.8),
            itemBuilder: (context, index) {
              return Shimmer(
                color: Colors.grey,
                child: Card(
                  margin: EdgeInsets.all(4),
                ),
              );
            });
      },
    );
  }
}
