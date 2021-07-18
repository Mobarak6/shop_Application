import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final String title;

  final int quintity;

  CartItem(this.id, this.productId, this.price, this.title, this.quintity);

  @override
  Widget build(BuildContext context) {
    final items = Provider.of<Cart>(context, listen: false);
    return Dismissible(
      onDismissed: (direction) => items.removeItem(productId),
      direction: DismissDirection.endToStart,
      key: ValueKey(id),
      background: Container(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
        color: Theme.of(context).errorColor,
      ),
      child: Card(
          child: ListTile(
        leading: CircleAvatar(
            child: FittedBox(
                child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('$price'),
        ))),
        title: Text(title),
        subtitle: Text(
          'Total: ${(price * quintity).toStringAsFixed(2)} BDT',
        ),
        trailing: FittedBox(
          child: Container(
            child: Row(
              children: [
                InkWell(
                  onTap: () => items.decreaseItem(productId),
                  child: Text(
                    '- ',
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).errorColor,
                    ),
                  ),
                ),
                Chip(
                  label: Text('x$quintity'),
                ),
                InkWell(
                  onTap: () => items.incriseItem(productId),
                  child: Text(
                    ' +',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
