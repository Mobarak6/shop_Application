import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/Authentication.dart';

import '/providers/cart.dart';
import '/providers/order.dart';
import '/screens/order_screen.dart';
import '../widgets/cart_item.dart' as Card;

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);
  static const routeName = '/Cart_Screen';

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  var _isInit = true;
  var _isLoading = true;

  @override
  Future<void> didChangeDependencies() async {
    if (_isInit) {
      await Provider.of<Cart>(context, listen: false)
          .facthCartItem(
              Provider.of<Authentication>(context, listen: false).userId,
              Provider.of<Authentication>(context, listen: false).idToken)
          .then((value) {
        setState(() {
          _isLoading = false;
          _isInit = false;
        });
      });

      //_isLoading = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    //log('Cart Screen');
    final item = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('My Cart'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Amount'),
                        Spacer(),
                        Chip(
                          backgroundColor: Theme.of(context).primaryColor,
                          label: Text(
                              '${item.totalAmount.toStringAsFixed(2)} BDT'),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Consumer<Order>(
                          builder: (context, value, _) => item.Len > 0
                              ? OutlinedButton(
                                  onPressed: () {
                                    value.addOrder(
                                        item.items.values.toList(),
                                        item.totalAmount,
                                        Provider.of<Authentication>(context,
                                                listen: false)
                                            .userId,
                                        Provider.of<Authentication>(context,
                                                listen: false)
                                            .idToken);

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Order done!'),
                                        duration: Duration(seconds: 1),
                                      ),
                                    );
                                    item.clear(
                                      Provider.of<Authentication>(context,
                                              listen: false)
                                          .userId,
                                      Provider.of<Authentication>(context,
                                              listen: false)
                                          .idToken,
                                    );

                                    Navigator.pushReplacementNamed(
                                        context, OrderScreen.routeName);

                                    //item.items.values.toList();
                                  },
                                  child: Text('Order Now'),
                                )
                              : OutlinedButton(
                                  onPressed: null,
                                  child: Text('Order Now'),
                                ),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: item.Len,
                      itemBuilder: (context, i) => Card.CartItem(
                            item.items.values.toList()[i].id,
                            item.items.keys.toList()[i],
                            item.items.values.toList()[i].price,
                            item.items.values.toList()[i].title,
                            item.items.values.toList()[i].quentity,
                          )),
                )
              ],
            )),
    );
  }
}
