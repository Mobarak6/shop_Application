import 'package:flutter/material.dart';

import 'package:shop_app/widgets/logInForm.dart';

enum PageSelect {
  logIn,
  signUp,
}

class LoginScreen extends StatefulWidget {
  static const String routeName = '/loginScreen';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var _emailControler = TextEditingController();
  var _passwordControler = TextEditingController();
  PageSelect _pageSelect = PageSelect.logIn;

  // bool _signUpButton = true;
  // bool _isLoading = false;
  late LoginForm _loginForm;

  //var _loginForm = LoginForm(_emailControler, _passwordControler, _pageSelect);
  @override
  void initState() {
    _loginForm = LoginForm(_emailControler, _passwordControler, _pageSelect);
    // log('init');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //log('Log in');

    final mediaQuery = MediaQuery.of(context);
    final height = mediaQuery.size.height - mediaQuery.viewInsets.bottom;
    // log('log height : $height');

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: height,
          // color: Colors.black12,
          //height: mediaQuerySize * 0.8,
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: height * 0.16,
              ),
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
              SizedBox(
                height: height * 0.08,
              ),
              Flexible(
                child: _loginForm,
              ),
              //LoginForm(_emailControler, _passwordControler, _pageSelect),
            ],
          ),
        ),
      ),
    );
  }
}
