import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import 'package:hirdey_mittal/views/notes/notes_view.dart';

class hiddenDrawer extends StatefulWidget {
  const hiddenDrawer({Key? key}) : super(key: key);

  @override
  State<hiddenDrawer> createState() => _hiddenDrawerState();
}

class _hiddenDrawerState extends State<hiddenDrawer> {
  final _pages = [
    ScreenHiddenDrawer(
      ItemHiddenMenu(
        name: 'Notes',
        baseStyle: TextStyle(),
        selectedStyle: TextStyle(),
      ),
      NotesView(),
    )
  ];
  @override
  Widget build(BuildContext context) {
    return HiddenDrawerMenu(
      screens: _pages,
      backgroundColorMenu: Colors.white,
    );
  }
}
