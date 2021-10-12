import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/reloadingHandel.dart';
import 'package:shop_app/providers/Authentication.dart';
import 'package:shop_app/screens/logInScreen.dart';

import 'dialog.dart';

class LoginForm extends StatefulWidget {
  TextEditingController _emailControler = TextEditingController();
  TextEditingController _passwordControler = TextEditingController();
  TextEditingController _rePasswordControler = TextEditingController();
  PageSelect? _pageSelect;

  LoginForm(
    this._emailControler,
    this._passwordControler,
    this._pageSelect,
  );

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  var _isLoading = false;
  bool _signUpButton = true;

  @override
  Widget build(BuildContext context) {
    //log('login form');
    final med = MediaQuery.of(context).size.height;
    //log(med.toString());

    return Column(
      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Form(
          //autovalidate: true,
          // autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintStyle: const TextStyle(fontWeight: FontWeight.w300),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  labelText: 'Mail',
                  prefixIcon: const Icon(Icons.mail),
                ),
                controller: widget._emailControler,
              ),
              SizedBox(
                height: med * 0.01,
              ),
              TextFormField(
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  hintStyle: const TextStyle(fontWeight: FontWeight.w300),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.privacy_tip),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        ReloadingHandel.hidePassord =
                            !ReloadingHandel.hidePassord;
                      });
                    },
                    icon: ReloadingHandel.hidePassord
                        ? Icon(Icons.remove_red_eye)
                        : Icon(Icons.ac_unit),
                  ),
                ),
                controller: widget._passwordControler,
                obscureText: ReloadingHandel.hidePassord,
              ),
              SizedBox(
                height: med * 0.01,
              ),
              widget._pageSelect == PageSelect.signUp
                  ? TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        hintStyle: const TextStyle(fontWeight: FontWeight.w300),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        labelText: 'Re-Password',
                        prefixIcon: const Icon(Icons.privacy_tip),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              ReloadingHandel.hidePassord =
                                  !ReloadingHandel.hidePassord;
                            });
                          },
                          icon: ReloadingHandel.hidePassord
                              ? Icon(Icons.remove_red_eye)
                              : Icon(Icons.ac_unit),
                        ),
                      ),
                      controller: widget._rePasswordControler,
                      obscureText: ReloadingHandel.hidePassord,
                      validator: (value) {
                        if (widget._passwordControler != value) {
                          return 'Password not Match';
                        }
                      },
                    )
                  : SizedBox(),
            ],
          ),
        ),
        // Flexible(
        //   child: SizedBox(height: med * 0.35),
        // ),
        AnimatedContainer(
          duration: Duration(milliseconds: 5),
          curve: Curves.bounceInOut,
          // color: Colors.black12,
          //padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
          // height: med * 0.3,
          child: Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      if (widget._pageSelect == PageSelect.logIn) {
                        widget._pageSelect = PageSelect.signUp;
                      } else {
                        widget._pageSelect = PageSelect.logIn;
                      }
                      _signUpButton = !_signUpButton;
                    });
                    // log('text Inkwell');
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(5, 0, 0, 5),
                    child: widget._pageSelect == PageSelect.logIn
                        ? const Text(
                            'Not Acount? Sign up',
                            style: TextStyle(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.w600),
                          )
                        : const Text(
                            'Already have an Acount  ',
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
                            if (widget._pageSelect == PageSelect.logIn) {
                              try {
                                value
                                    .authFunction(
                                        widget._emailControler.text,
                                        widget._passwordControler.text,
                                        'signInWithPassword')
                                    .catchError((context) {})
                                    .then((value) {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                });
                              } catch (e) {
                                DialogView.DialogViewFun(context, e.toString());
                              }
                            } else {
                              try {
                                value
                                    .authFunction(
                                        widget._emailControler.text,
                                        widget._passwordControler.text,
                                        'signUp')
                                    .then((value) {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                });
                              } catch (e) {
                                DialogView.DialogViewFun(context, e.toString());
                              }
                            }
                            //log('submited done ' + _emailControler.text),
                          },
                          icon: const Icon(
                            Icons.done,
                            color: Colors.white,
                          ),
                          label: widget._pageSelect == PageSelect.logIn
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
          ),
        )
      ],
    );
  }
}
