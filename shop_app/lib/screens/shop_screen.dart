import 'package:flutter/material.dart';

import '/screens/CartScreen.dart';
import '/widgets/grid_Item.dart';

enum FilterOption {
  all,
  favorit,
}

class ShopScreen extends StatefulWidget {
  //static final routeName = '/ShopScreen_';
  @override
  _ShopScreenState createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  var _showfavorit = false;
  // int _selectedIndex = 0;
  // void _onItemTapped(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    //print('ShopScreen');
    // final List<Widget> _widgetOptions = <Widget>[
    //   GridItem(_showfavorit),
    //   OrderScreen(),
    //   UserProductScreen(),
    // ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Shop'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, CartScreen.routeName);
            },
            icon: Icon(Icons.shopping_cart),
          ),
          PopupMenuButton(
              onSelected: (FilterOption value) {
                setState(() {
                  if (value == FilterOption.favorit) {
                    _showfavorit = true;
                  } else {
                    _showfavorit = false;
                  }
                });
              },
              itemBuilder: (context) => [
                    PopupMenuItem<FilterOption>(
                      value: FilterOption.favorit,
                      child: Text('Only Fovorite '),
                    ),
                    PopupMenuItem<FilterOption>(
                      value: FilterOption.all,
                      child: Text('Show All'),
                    ),
                  ])
        ],
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   //backgroundColor: Theme.of(context).primaryColor,
      //   items: const <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.shop),
      //       label: 'Product',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.bookmark_outline),
      //       label: 'Order',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.business),
      //       label: 'My Product',
      //     ),
      //   ],
      //   currentIndex: _selectedIndex,
      //   selectedItemColor: Colors.amber[800],
      //   onTap: _onItemTapped,
      // ),
      body: GridItem(_showfavorit),
    );
  }
}
