import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/providers/products_provider.dart';
import '/screens/user_product_form.dart';
import '/widgets/user_product_item.dart';

class UserProductScreen extends StatefulWidget {
  const UserProductScreen({Key? key}) : super(key: key);

  @override
  _UserProductScreenState createState() => _UserProductScreenState();
}

class _UserProductScreenState extends State<UserProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('My Product'),
        ),
        floatingActionButton: IconButton(
          onPressed: () {
            setState(() {
              Navigator.pushNamed(context, UserProductForm.routeName);
            });
          },
          icon: Icon(
            Icons.add,
            //color: Colors.white,
          ),
        ),
        body: Padding(
            padding: const EdgeInsets.all(15),
            child: Consumer<Products>(
                builder: (context, value, _) => ListView.builder(
                      itemBuilder: (context, i) =>
                          UserProductItem(value.DUMMY_ITEMS[i]),
                      itemCount: value.DUMMY_ITEMS.length,
                    ))));
  }
}
