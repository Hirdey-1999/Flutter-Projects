import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hirdey_mittal/constants/routes.dart';
import 'package:hirdey_mittal/service/auth/auth_exceptions.dart';
import 'package:hirdey_mittal/service/auth/auth_service.dart';
import 'package:hirdey_mittal/utilities/dialogs/error_dialog.dart';
import '../firebase_options.dart';
import 'dart:developer' as devtools show log;

class RegisterView extends StatefulWidget {
  const RegisterView({ Key? key }) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
    return Center(
      child: Scaffold(
        appBar: AppBar(title: Text('Register'),),
        body: Padding(
          padding: const EdgeInsets.only(top: 156.0),
          child: Column(
                  children: [
                    Title(color: Colors.black, child: Text('Register Page', style: TextStyle(fontWeight: FontWeight.bold, ),textScaleFactor: 1.5,)),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: TextField(
                      controller: _email,
                      enableSuggestions: false,
                      autocorrect: false,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(border: OutlineInputBorder(),labelText: 'Email', ),
                  ),
                    ),
                  TextField(
                    controller: _password,
                    obscureText: _isObscure,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: InputDecoration(border: OutlineInputBorder(),labelText: 'Password',
                    suffixIcon: IconButton(icon: Icon(
                      _isObscure ? Icons.visibility : Icons.visibility_off,), onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },)),
                  ),
                  TextButton(onPressed: () async {
                    final email = _email.text;
                    final password  = _password.text;
                    showAlertDialog(context, 'Check Your Email For Verification');
                    try{
                    final usercredential = await AuthService.firebase().createUser(email: email, password: password);
                    devtools.log(usercredential.toString());
                    await AuthService.firebase().sendEmailVerification();
                    
                    Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (route) => false);
                    // Navigator.of(context).pushNamed(verifyEmailRoute);
                    }
                    on WeakPasswordAuthExcepton{
                      devtools.log('Weak Password');
                      showErrorDialog(context, 'Weak Password');
                    }
                    on EmailAlreadyInUseAuthExcepton{
                       devtools.log('Email Already In Use');
                      showErrorDialog(context, 'Email Already In Use');
                    } 

                    on InvalidEmailAuthExcepton{
                      devtools.log('Invalid Email');
                      showErrorDialog(context, 'Invalid Email');
                    } 
                    on GenericAuthExcepton{
                      showErrorDialog(context, 'Error: Failed To Register');
                    }
 
                  },child: const Text('Register'),
                  ),
                  TextButton(onPressed: (){
                  Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (route) => false);
                }, child: const Text('Already Registered? Login Now')),
                  Image.asset(
                    'images/register.jpg',
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
        ),
      ),
    );
  }
}
