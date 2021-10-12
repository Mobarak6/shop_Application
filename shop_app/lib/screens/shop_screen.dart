import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/reloadingHandel.dart';
import 'package:shop_app/providers/Authentication.dart';
import 'package:shop_app/providers/products_provider.dart';

import 'package:shop_app/widgets/dialog.dart';

import '/screens/CartScreen.dart';
import '/widgets/grid_Item.dart';

enum FilterOption { all, favorit, logOut }

class ShopScreen extends StatefulWidget {
  static final routeName = '/ShopScreen_';
  @override
  _ShopScreenState createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  var _showfavorit = false;

  var _isLoading = true;
  late Future _initFunction;

  @override
  void initState() {
    _initFunction = _productFacthData().then((value) {
      setState(() {
        _isLoading = false;
      });
    });

    super.initState();
  }
  //CUPo9YtKHLZMPqUEMrNaS4PcMDz2

  Future<void> _productFacthData() async {
    await Provider.of<Products>(context, listen: false)
        .facthData(
      Provider.of<Authentication>(context, listen: false),
    )
        .catchError((error) {
      DialogView.DialogViewFun(context, 'Something Wrong!').then((value) {
        setState(() {
          _isLoading = false;
        });
      });
    });
  }

  Future<void> _onRefresh(BuildContext context) async {
    ReloadingHandel.productHandel = true;
    await _productFacthData();

    // log('Referess Function call');
  }

  @override
  Widget build(BuildContext context) {
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
                  switch (value) {
                    case FilterOption.favorit:
                      _showfavorit = true;
                      break;
                    case FilterOption.logOut:
                      Navigator.of(context).pushReplacementNamed('/');
                      Provider.of<Authentication>(context, listen: false)
                          .logOut();
                      // Navigator.of(context).pop();
                      break;
                    default:
                      _showfavorit = false;
                  }
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
                    PopupMenuItem<FilterOption>(
                      value: FilterOption.logOut,
                      child: Text('Log-Out'),
                    ),
                  ])
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _onRefresh(context),
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : GridItem(_showfavorit),
      ),
    );
  }
}
