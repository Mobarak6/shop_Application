import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/providers/Authentication.dart';
import '/providers/products_provider.dart';
import '/screens/user_product_form.dart';
import '/widgets/user_product_item.dart';

class UserProductScreen extends StatelessWidget {
  const UserProductScreen({Key? key}) : super(key: key);

  Future<void> refreshProduct(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).facthUserProduct(
      Provider.of<Authentication>(context, listen: false),
      // Provider.of<Authentication>(context, listen: false).userId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('My Product'),
          actions: [
            TextButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, UserProductForm.routeName);
              },
              icon: const Icon(
                Icons.add_circle_sharp,
                color: Colors.white,
              ),
              label: const Text(
                'Add',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        body: FutureBuilder(
          future: refreshProduct(context),
          builder: (context, snapshot) => snapshot.connectionState ==
                  ConnectionState.waiting
              ? Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: () => refreshProduct(context),
                  child: Consumer<Products>(
                    builder: (context, products, _) => Padding(
                      padding: const EdgeInsets.all(15),
                      child: ListView.builder(
                        itemCount: products.DUMMY_ITEMS.length,
                        itemBuilder: (context, i) =>
                            UserProductItem(products.DUMMY_ITEMS[i], products),
                      ),
                    ),
                  ),
                ),
        ));
  }
}
