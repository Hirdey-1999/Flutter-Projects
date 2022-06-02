import 'package:flutter/material.dart';
import 'package:hirdey_mittal/utilities/dialogs/generic_dialogs.dart';

Future<void> showCannotShareEmptyNoteDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: 'Sharing',
    content: 'Cannot Share An Empty Note',
    optionsBuilder: () => {
      'OK': null,
    },
  );
}
