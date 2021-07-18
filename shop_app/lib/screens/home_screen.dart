import 'package:flutter/material.dart';

import '/screens/shop_screen.dart';
import '/screens/user_product.dart';

import 'order_screen.dart';

enum FilterOption {
  all,
  favorit,
}

class HomeScreenAll extends StatefulWidget {
  static const routeName = 'HomeScreenAll';
  const HomeScreenAll({Key? key}) : super(key: key);

  @override
  _HomeScreenAllState createState() => _HomeScreenAllState();
}

class _HomeScreenAllState extends State<HomeScreenAll> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _widgetOptions = <Widget>[
      ShopScreen(),
      OrderScreen(),
      UserProductScreen(),
    ];

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        //backgroundColor: Theme.of(context).primaryColor,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.shop),
            label: 'Product',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_outline),
            label: 'Order',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'My Product',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
    );
  }
}
