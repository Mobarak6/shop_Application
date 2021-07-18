import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/models/product.dart';
import '/providers/cart.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final item = Provider.of<Product>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      child: GridTile(
          child: Image.network(
            item.imageUrl,
            fit: BoxFit.cover,
          ),
          footer: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: GridTileBar(
                  backgroundColor: Colors.black54,
                  leading: Consumer<Product>(
                    builder: (context, item, _) => IconButton(
                      icon: item.isFavorite == true
                          ? Icon(
                              Icons.favorite,
                              color: Colors.redAccent,
                            )
                          : Icon(Icons.favorite_border_outlined),
                      onPressed: () => item.switchFavorit(),
                    ),
                  ),
                  title: FittedBox(
                    child: Text(
                      'BDT ${item.price}',
                      style: Theme.of(context).textTheme.headline6,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  trailing: Consumer<Cart>(
                    builder: (context, cartitem, _) => IconButton(
                        icon: Icon(Icons.shopping_cart_outlined),
                        onPressed: () {
                          cartitem.addCart(item.id, item.title, item.price);
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: const Text('Added Done!'),
                            duration: Duration(seconds: 0.7.toInt()),
                          ));
                          //print('${cartitem.items[0]!.title}');
                          //print(cartitem.Len.toString());
                        }),
                  )),
            ),
          )),
    );
  }
}
