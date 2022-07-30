import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hirdey_mittal/constants/routes.dart';
import 'package:hirdey_mittal/service/auth/auth_exceptions.dart';
import 'package:hirdey_mittal/service/auth/auth_service.dart';
import 'package:hirdey_mittal/utilities/dialogs/error_dialog.dart';
import '../firebase_options.dart';
import 'dart:developer' as devtools show log;

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

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
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 50,),
              SvgPicture.asset('assets/icons/signup.svg',),
                  Text(
                    'A New Start',
                    style: GoogleFonts.bebasNeue(
                      fontSize: 45,
                      letterSpacing: 8,
                      wordSpacing: 10,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Start Your Writing Journey At Elunote',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:25.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 20.0,
                    ),
                    child: TextField(
                      controller: _email,
                      enableSuggestions: false,
                      autocorrect: false,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Email',
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left:20.0),
                    child: TextField(
                      controller: _password,
                      obscureText: _isObscure,
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Password',
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
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:25.0),
                child: Container(width: double.infinity,
                decoration: BoxDecoration(color: Colors.deepPurple,borderRadius: BorderRadius.circular(12)),
                  child: TextButton(
                    onPressed: () async {
                      final email = _email.text;
                      final password = _password.text;
                      showAlertDialog(context, 'Check Your Email For Verification');
        
                      try {
                        final usercredential = await AuthService.firebase()
                            .createUser(email: email, password: password);
                        devtools.log(usercredential.toString());
                        await AuthService.firebase().sendEmailVerification();
        
                        Navigator.of(context)
                            .pushNamedAndRemoveUntil(loginRoute, (route) => false);
                        // Navigator.of(context).pushNamed(verifyEmailRoute);
                      } on WeakPasswordAuthExcepton {
                        devtools.log('Weak Password');
                        showErrorDialog(context, 'Weak Password');
                      } on EmailAlreadyInUseAuthExcepton {
                        devtools.log('Email Already In Use');
                        showErrorDialog(context, 'Email Already In Use');
                      } on InvalidEmailAuthExcepton {
                        devtools.log('Invalid Email');
                        showErrorDialog(context, 'Invalid Email');
                      } on GenericAuthExcepton {
                        showErrorDialog(context, 'Error: Failed To Register');
                      }
                    },
                    child: const Text('Register',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),),
                  ),
                ),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(loginRoute, (route) => false);
                  },
                  child: Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already Registered?', style: TextStyle(color: Colors.black),),
                      const Text('Login Now',),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
