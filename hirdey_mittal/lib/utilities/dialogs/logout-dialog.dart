import 'package:flutter/material.dart';
import 'package:hirdey_mittal/utilities/dialogs/generic_dialogs.dart';

Future <bool> showLogOutDialog(BuildContext context) {
  return showGenericDialog<bool>(context: context, title: 'Log-Out', content: "Are You Sure You Wanna Logout", optionsBuilder: () => {
    'Cancel': false,
    'LogOut': true,
  }).then((value) => value ?? false,);
}