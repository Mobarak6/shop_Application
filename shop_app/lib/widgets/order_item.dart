import 'package:flutter/material.dart';
import 'dart:math';
import 'package:intl/intl.dart';

import '/providers/order.dart' as model;

class OrderItem extends StatefulWidget {
  final model.OrderItem item;
  OrderItem(
    this.item,
  );

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _selected = false;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.all(15),
      child: Card(
        elevation: 5,
        child: Column(
          children: [
            ListTile(
              leading: CircleAvatar(
                child: FittedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(widget.item.amount.toStringAsFixed(2)),
                  ),
                ),
              ),
              subtitle: Text(
                DateFormat('mm: hh').format(widget.item.dateTime),
                style: TextStyle(fontWeight: FontWeight.w100),
              ),
              title: Text(DateFormat('dd/MM/yy').format(widget.item.dateTime)),
              trailing: IconButton(
                onPressed: () {
                  setState(() {
                    _selected = !_selected;
                  });
                },
                icon: _selected
                    ? Icon(Icons.expand_less)
                    : Icon(Icons.expand_more),
              ),
            ),
            if (_selected)
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Container(
                    height: min((widget.item.products.length + 1) * 20, 400),
                    child: ListView.builder(
                      itemBuilder: (context, i) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: mediaQuery.width * 0.20,
                            child: Text(
                              '${widget.item.products[i].title} ',
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ),
                          SizedBox(
                            // width: (mediaQuery.width -
                            //         (paddingSize.left + paddingSize.right)) *
                            //     0.30,
                            child: FittedBox(
                              child: Text(
                                'BDT-  ${widget.item.products[i].price} x ${widget.item.products[i].quentity}',
                                // style: TextStyle(
                                //   fontSize: 12,
                                // ),
                              ),
                            ),
                          ),
                          FittedBox(
                            child: Container(
                              alignment: Alignment.centerLeft,
                              color: Colors.blue,
                              // width: (mediaQuery.width -
                              //         (paddingSize.left + paddingSize.right)) *
                              //     0.40,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: FittedBox(
                                  child: FittedBox(
                                    child: Text(
                                      'BDT- ${(widget.item.products[i].price * widget.item.products[i].quentity).toStringAsFixed(2)}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                        backgroundColor: Colors.blue,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      itemCount: widget.item.products.length,
                    )),
              )
          ],
        ),
      ),
    );
  }
}
