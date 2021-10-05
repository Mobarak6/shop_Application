import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shop_app/widgets/formWidget.dart';

class LogInSignInScreen extends StatelessWidget {
  const LogInSignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    log('LogInSignInScreen()');
    final mediaQuery = MediaQuery.of(context);
    final height = mediaQuery.size.height - mediaQuery.viewInsets.bottom;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: height,
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          color: Colors.black12,
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const Text(
                    'Sign in to continue!',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              //FittedBox(child: FormWidget()),
            ],
          ),
        ),
      ),
    );
  }
}
