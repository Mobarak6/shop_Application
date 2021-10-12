import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/Authentication.dart';
import 'package:shop_app/screens/productDetailsPage.dart';

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
      child: InkWell(
        onTap: () => Navigator.of(context)
            .pushNamed(ProductDetailsScreen.routeName, arguments: item),
        child: GridTile(
          header: Container(
            alignment: Alignment.center,
            color: Colors.black38,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: Text(
                      item.title,
                      style: TextStyle(color: Colors.white, fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
          child: Image.network(
            item.imageUrl,
            fit: BoxFit.cover,
          ),
          footer: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              color: Colors.black38,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Consumer<Product>(
                    builder: (context, item, _) => IconButton(
                      icon: item.isFavorite == true
                          ? Icon(
                              Icons.favorite,
                              color: Colors.redAccent,
                            )
                          : Icon(
                              Icons.favorite_border_outlined,
                              color: Colors.white,
                            ),
                      onPressed: () => item.switchFavorit(
                          Provider.of<Authentication>(context, listen: false),
                          item.id),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'BDT ${item.price}',
                      //style: Theme.of(context).textTheme.headline6,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        //fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Consumer<Cart>(
                    builder: (context, cartitem, _) => IconButton(
                        icon: Icon(
                          Icons.shopping_cart_outlined,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          cartitem.addCart(
                            item.id,
                            item.title,
                            item.price,
                            Provider.of<Authentication>(context, listen: false)
                                .userId,
                            Provider.of<Authentication>(context, listen: false)
                                .idToken,
                          );
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: const Text('Added Done!'),
                            duration: Duration(seconds: 0.7.toInt()),
                          ));
                        }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
