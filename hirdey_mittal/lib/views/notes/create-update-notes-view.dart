import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hirdey_mittal/service/auth/auth_service.dart';
import 'package:hirdey_mittal/service/crud/notes_service.dart';
import 'package:hirdey_mittal/utilities/generics/get_argument.dart';

class createUpdateNoteView extends StatefulWidget {
  const createUpdateNoteView({Key? key}) : super(key: key);

  @override
  State<createUpdateNoteView> createState() => _createUpdateNoteViewState();
}

class _createUpdateNoteViewState extends State<createUpdateNoteView> {

  DatabaseNotes? _notes;
  late final noteService _notesService;
  late final TextEditingController _textcontroller;

  @override
  void initState(){
    _notesService = noteService();
    _textcontroller = TextEditingController();
    super.initState();
  }
  void _textcontrollerListener() async {
    final note = _notes;
    if(note==null){
      return;
    }
    final text = _textcontroller.text;
    await _notesService.updateNote(note: note, text: text);
  }

  void _setuptextcontrollerListener() {
    _textcontroller.removeListener(_textcontrollerListener);
    _textcontroller.addListener(_textcontrollerListener);
  }

  Future<DatabaseNotes> createOrGetExistingNote(BuildContext context) async {

    final widgetNote = context.getArgument<DatabaseNotes>();
    if(widgetNote != null){
      _notes = widgetNote;
      _textcontroller.text = widgetNote.text;
      return widgetNote;
    }

    final existingNote = _notes;
    if(existingNote != null){
      return existingNote;
    }
    final currentUser = AuthService.firebase().currentUser!;
    final email = currentUser.email;
    final owner = await _notesService.getUser(email: email);
    final newNote = await _notesService.createNote(owner: owner);
    _notes = newNote;
    return newNote;
    }

    void _deleteNoteifTextisEmpty() {
      final note = _notes;
      if(_textcontroller.text.isEmpty && note!=null){
        _notesService.deleteNote(id: note.id);
      }
    }
    void _saveNoteifTextisNotEmpty() async {
      final note = _notes;
      final text = _textcontroller.text;
      if(text.isNotEmpty && note!=null){
        await _notesService.updateNote(note: note, text: text);
      }
    }

    @override
  void dispose() {
    _deleteNoteifTextisEmpty();
    _saveNoteifTextisNotEmpty();
    _textcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Notes View')),
      body: 
      FutureBuilder(future: createOrGetExistingNote(context),builder: (context, snapshot) { 
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            _setuptextcontrollerListener();
            return TextField(
              controller: _textcontroller,
              keyboardType: TextInputType.multiline,
              maxLines: max(0, 30),
              decoration: const InputDecoration( hintText: 'Write Your Note Here', border: UnderlineInputBorder()),
            );
          default: 
          return const CircularProgressIndicator();
        }
      },),);
  }
}