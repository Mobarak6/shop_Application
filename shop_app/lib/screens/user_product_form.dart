import 'package:flutter/material.dart';

class UserProductForm extends StatelessWidget {
  static const routeName = '/user_product_form';
  const UserProductForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Form'),
      ),
      body: Center(child: Text(routeName)),
    );
  }
}
