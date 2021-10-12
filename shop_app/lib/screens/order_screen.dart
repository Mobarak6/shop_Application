import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/Authentication.dart';

import 'package:shop_app/widgets/dialog.dart';

import '/providers/order.dart';
import '/widgets/order_item.dart' as widget;

class OrderScreen extends StatefulWidget {
  static const routeName = '/order_Screen';

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  var _isLoading = true;
  var _isInt = true;

  @override
  void didChangeDependencies() async {
    if (_isInt) {
      Provider.of<Order>(context, listen: false)
          .facthOrder(
              Provider.of<Authentication>(context, listen: false).userId,
              Provider.of<Authentication>(context, listen: false).idToken)
          .then((value) {
        setState(() {
          _isLoading = false;
        });
      }).catchError((error) {
        DialogView.DialogViewFun(context, 'Something Wrong!').then((value) {
          setState(() {
            _isLoading = false;
          });
        });
      });
    }

    // Provider.of<Order>(context, listen: false).items;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    //log('order Screen');
    return Scaffold(
        appBar: AppBar(
          title: Text('Order'),
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(8),
                child: Consumer<Order>(
                  builder: (context, value, _) => ListView.builder(
                    itemBuilder: (context, i) => widget.OrderItem(
                      value.items[i],
                    ),
                    itemCount: value.items.length,
                  ),
                ),
              ));
  }
}
