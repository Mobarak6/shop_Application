import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop_app/providers/Authentication.dart';
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
  bool _signUpButton = true;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    //log('Log in');
    final mediaQuerySize = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Padding(
        // color: Colors.black12,
        //height: mediaQuerySize * 0.8,
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: mediaQuerySize * 0.16,
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
                  height: mediaQuerySize * 0.08,
                ),
                LoginForm(_emailControler, _passwordControler, _pageSelect),
              ],
            ),
            Container(
              // color: Colors.red,
              //padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
              // height: mediaQuerySize * 0.5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        if (_pageSelect == PageSelect.logIn) {
                          _pageSelect = PageSelect.signUp;
                        } else {
                          _pageSelect = PageSelect.logIn;
                        }
                        _signUpButton = !_signUpButton;
                      });
                      // log('text Inkwell');
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 0, 5),
                      child: _pageSelect == PageSelect.logIn
                          ? const Text(
                              'Already have an Acount',
                              style: TextStyle(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.w600),
                            )
                          : const Text(
                              'Not Acount? Sign up',
                              style: TextStyle(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.w600),
                            ),
                    ),
                  ),
                  Consumer<Authentication>(
                    builder: (context, value, _) => _isLoading
                        ? Center(child: CircularProgressIndicator())
                        : OutlinedButton.icon(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.redAccent),
                            ),
                            onPressed: () {
                              setState(() {
                                _isLoading = true;
                              });
                              if (_pageSelect == PageSelect.logIn) {
                                value
                                    .authFunction(
                                        _emailControler.text,
                                        _passwordControler.text,
                                        'signInWithPassword')
                                    .then((value) {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                });
                              } else {
                                value
                                    .authFunction(_emailControler.text,
                                        _passwordControler.text, 'signUp')
                                    .then((value) {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                });
                              }
                              //log('submited done ' + _emailControler.text),
                            },
                            icon: const Icon(
                              Icons.done,
                              color: Colors.white,
                            ),
                            label: _pageSelect == PageSelect.logIn
                                ? const Text(
                                    'Login',
                                    style: TextStyle(color: Colors.white),
                                  )
                                : const Text(
                                    'SignUp',
                                    style: TextStyle(color: Colors.white),
                                  ),
                          ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
