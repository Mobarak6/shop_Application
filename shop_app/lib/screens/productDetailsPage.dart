import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/product.dart';
import 'package:shop_app/providers/Authentication.dart';
import 'package:shop_app/providers/cart.dart';

class ProductDetailsScreen extends StatelessWidget {
  static const String routeName = 'ProductDetailsScreen';
  const ProductDetailsScreen({Key? key}) : super(key: key);
  Widget textWidget(String getString) {
    return Text(
      getString,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.white,
        fontSize: 20,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final item = ModalRoute.of(context)!.settings.arguments as Product;
    final size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Color.fromRGBO(41, 41, 41, 5),
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(41, 41, 41, 5),
          title: Text(item.title),
          centerTitle: true,
          elevation: 0,
        ),
        body: Padding(
          padding: EdgeInsets.only(
              left: size.width * 0.02, right: size.width * 0.02),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: size.height * 0.3,
                      width: double.infinity,
                      child: Image.network(
                        item.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: size.height * 0.03),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item.title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            'BDT ${item.price}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: size.height * 0.05),
                      child: textWidget('Discription: '),
                    ),
                    Text(
                      item.description,
                      style: TextStyle(color: Colors.white54),
                    ),
                  ],
                ),
              ),
              Consumer<Cart>(
                builder: (context, cartItem, _) => Container(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.green),
                      ),
                      onPressed: () {
                        cartItem.addCart(
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
                      },
                      icon: Icon(Icons.shopping_cart),
                      label: Text('Add to cart')),
                ),
              )
            ],
          ),
        ));
  }
}
