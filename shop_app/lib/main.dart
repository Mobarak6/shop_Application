import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/providers/cart.dart';
import '/providers/order.dart';
import '/providers/products_provider.dart';
import '/screens/CartScreen.dart';
import '/screens/home_screen.dart';
import '/screens/order_screen.dart';
import '/screens/user_product_form.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Products(),
        ),
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (context) => Order(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Shop',
        theme: ThemeData(
          textTheme: TextTheme(
              headline6: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
          )),
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        initialRoute: HomeScreenAll.routeName,
        routes: {
          HomeScreenAll.routeName: (context) => HomeScreenAll(),
          CartScreen.routeName: (context) => CartScreen(),
          UserProductForm.routeName: (context) => UserProductForm(),
          OrderScreen.routeName: (context) => OrderScreen(),
        },
      ),
    );
  }
}
