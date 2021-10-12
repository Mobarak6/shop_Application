import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/Authentication.dart';

import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/screens/user_product_form.dart';
import '/models/product.dart';

class UserProductItem extends StatefulWidget {
  final Product product;
  final Products products;

  UserProductItem(this.product, this.products);

  static final String routeName = 'UserProductRouteName';

  @override
  _UserProductItemState createState() => _UserProductItemState();
}

class _UserProductItemState extends State<UserProductItem> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    // log("userProductWidget");
    final double w = MediaQuery.of(context).size.width * 0.25;
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(widget.product.imageUrl),
                // child: Image.network(
                //   product.imageUrl,
                //   fit: BoxFit.fill,
                // ),
              ),
              title: Text(widget.product.title),
              trailing: Container(
                width: w,
                child: FittedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: Colors.blueAccent,
                        ),
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                            UserProductForm.routeName,
                            arguments: widget.product,
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          setState(() {
                            _isLoading = true;
                          });

                          widget.products
                              .delItem(
                                  widget.product.id,
                                  Provider.of<Authentication>(context,
                                      listen: false))
                              .then((_) {
                            setState(() {
                              _isLoading = false;
                            });
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
