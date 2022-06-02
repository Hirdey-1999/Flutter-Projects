import 'package:flutter/material.dart';
import 'package:hirdey_mittal/constants/routes.dart';
import 'package:hirdey_mittal/service/auth/auth_exceptions.dart';
import 'package:hirdey_mittal/service/auth/auth_service.dart';
import 'package:hirdey_mittal/utilities/dialogs/error_dialog.dart';
import 'register_view.dart';
import '../firebase_options.dart';
import 'dart:developer' as devtools show log;

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  bool _isObscure = true;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          children: [
            Image.asset(
              'images/login.jpg',
              width: 300,
              height: 300,
              fit: BoxFit.cover,
            ),
            Title(
                color: Colors.black,
                child: Text(
                  'Login Page',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  textScaleFactor: 1.5,
                )),
                
            Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: TextField(
                controller: _email,
                enableSuggestions: false,
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Email'),
              ),
            ),
            TextField(
              controller: _password,
              obscureText: _isObscure,
              enableSuggestions: false,
              autocorrect: false,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscure ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                  )),
            ),
            
            TextButton(
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;
                try {
                  final usercredential = await AuthService.firebase()
                      .logIn(email: email, password: password);
                  final user = AuthService.firebase().currentUser;
                  if (user?.isEmailVerified ?? false) {
                    // User Is Verified!!
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(notesRoute, (route) => false);
                  } else {
                    // User Is Not Verified
                    await showErrorDialog(
                        context, "Check Your Email Or Register Again");
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        registerRoute, (route) => false);
                  }

                  // devtools.log(usercredential.toString());
                } on UserNotFoundAuthException {
                  await showErrorDialog(context, 'User Not Found');
                  devtools.log('User Not Found');
                } on WrongPasswordAuthException {
                  await showErrorDialog(context, 'Entered Wrong Password');
                  devtools.log('Wrong Password');
                } on GenericAuthExcepton {
                  devtools.log('Something Went Wrong');
                  await showErrorDialog(context, 'Error: Authentication Error');
                  devtools.log('Authentication Error');
                }
              },
              child: const Text('Login'),
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(registerRoute, (route) => false);
                },
                child: const Text(
                  'Not Registered? SignUp Now',
                )),
          ],
        ),
      ),
    );
  }
}
