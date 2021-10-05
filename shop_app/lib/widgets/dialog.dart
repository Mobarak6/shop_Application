import 'package:flutter/material.dart';

class DialogView {
  late BuildContext context;
  //DialogView(this.context);

  static Future<void> DialogViewFun(context) async {
    showDialog(
        context: context,
        builder: (BuildContext ctx) => AlertDialog(
              title: const Text('Something Wrong!'),
              actions: [
                TextButton(
                  child: const Text('Ok'),
                  onPressed: () {
                    // setState(() {
                    //  // _isLoading = false;
                    // });

                    Navigator.of(ctx).pop();
                  },
                ),
              ],
            ));
  }
}
