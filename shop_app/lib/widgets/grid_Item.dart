import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/providers/products_provider.dart';
import '/widgets/productItem.dart';

class GridItem extends StatelessWidget {
  final bool showFov;
  GridItem(this.showFov);

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context, listen: false);
    final product = showFov ? productData.getFavorit : productData.DUMMY_ITEMS;
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 3, 15, 3),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          childAspectRatio: 3 / 2,
          mainAxisSpacing: 50,
          crossAxisSpacing: 50,
          maxCrossAxisExtent: 200,
          mainAxisExtent: 300,
        ),
        itemBuilder: (context, item) => ChangeNotifierProvider.value(
          value: product[item],
          child: ProductItem(),
        ),
        itemCount: product.length,
      ),
    );
  }
}
