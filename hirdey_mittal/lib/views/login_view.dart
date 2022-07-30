import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
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
  late final TextEditingController _email;
class _LoginViewState extends State<LoginView> {
  
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
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 50,),
                SvgPicture.asset('assets/icons/login.svg',),
                Text(
                  'Hello Again!',
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
                  'Welcome Back, You\'ve Been Missed ',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextField(
                        controller: _email,
                        enableSuggestions: false,
                        autocorrect: false,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Email',
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
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
                                _isObscure
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.black,
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
                  child: Container(
                    decoration: BoxDecoration(color: Colors.deepPurple,borderRadius: BorderRadius.circular(12)),
                    width: double.infinity,
                    child: TextButton(
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
                      child: const Text('Login',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),),
                    ),
                  ),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamedAndRemoveUntil(registerRoute, (route) => false);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Not a Member?',
                          style: TextStyle(color: Colors.black),
                        ),
                        const Text(
                          'Register Now!',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
