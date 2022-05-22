import 'package:flutter/material.dart';
import 'package:hirdey_mittal/utilities/dialogs/generic_dialogs.dart';

Future <bool> showDeleteDialog(BuildContext context) {
  return showGenericDialog<bool>(context: context, title: 'Delete Note', content: "Are You Sure You Wanna Delete The Note", optionsBuilder: () => {
    'Cancel': false,
    'Delete': true,
  }).then((value) => value ?? false,);
}