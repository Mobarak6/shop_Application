import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/providers/order.dart';
import '/widgets/order_item.dart' as widget;

class OrderScreen extends StatelessWidget {
  static const routeName = '/order_Screen';

  @override
  Widget build(BuildContext context) {
    // print('order Screen');
    return Scaffold(
        appBar: AppBar(
          title: Text('Order'),
        ),
        body: Padding(
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
