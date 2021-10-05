import 'package:flutter/material.dart';
import 'package:shop_app/models/reloadingHandel.dart';
import 'package:shop_app/screens/logInScreen.dart';

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
  @override
  Widget build(BuildContext context) {
    // log('login form');

    return Form(
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
            hintText: 'Mail',
            prefixIcon: const Icon(Icons.mail),
          ),
          controller: widget._emailControler,
        ),
        const SizedBox(
          height: 8,
        ),
        TextFormField(
          keyboardType: TextInputType.visiblePassword,
          decoration: InputDecoration(
            hintStyle: const TextStyle(fontWeight: FontWeight.w300),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            hintText: 'Password',
            prefixIcon: const Icon(Icons.privacy_tip),
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  ReloadingHandel.hidePassord = !ReloadingHandel.hidePassord;
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
        const SizedBox(
          height: 8,
        ),
        widget._pageSelect == PageSelect.signUp
            ? TextFormField(
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  hintStyle: const TextStyle(fontWeight: FontWeight.w300),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  hintText: 'Re-Password',
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
    ));
  }
}
