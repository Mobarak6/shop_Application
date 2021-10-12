import 'package:flutter/material.dart';

class DialogView {
  late BuildContext context;
  //DialogView(this.context);

  static Future<void> DialogViewFun(context, String message) async {
    showDialog(
        context: context,
        builder: (BuildContext ctx) => AlertDialog(
              title: Text(message),
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
