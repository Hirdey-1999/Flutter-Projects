import 'dart:math';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hirdey_mittal/service/auth/auth_service.dart';
import 'package:hirdey_mittal/utilities/dialogs/canot_share_empty_note_dialog.dart';
import 'package:hirdey_mittal/utilities/generics/get_argument.dart';
import 'package:hirdey_mittal/service/cloud/cloud_note.dart';
import 'package:hirdey_mittal/service/cloud/cloud_storage_exceptions.dart';
import 'package:hirdey_mittal/service/cloud/firebase_cloud_storage.dart';
import 'package:share_plus/share_plus.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class createUpdateNoteView extends StatefulWidget {
  const createUpdateNoteView({Key? key}) : super(key: key);

  @override
  State<createUpdateNoteView> createState() => _createUpdateNoteViewState();
}

class _createUpdateNoteViewState extends State<createUpdateNoteView> {
  CloudNote? _notes;
  late final FirebaseCloudStorage _notesService;
  late final TextEditingController _textcontroller;
  late stt.SpeechToText _speech;
  late bool _isListening = false;
  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    _textcontroller = TextEditingController();
    _speech = stt.SpeechToText();
    super.initState();
  }

  void _textcontrollerListener() async {
    final note = _notes;
    if (note == null) {
      return;
    }
    final text = _textcontroller.text;
    await _notesService.UpdateNote(
      documentID: note.documentID,
      text: text,
    );
  }

  void _setuptextcontrollerListener() {
    _textcontroller.removeListener(_textcontrollerListener);
    _textcontroller.addListener(_textcontrollerListener);
  }

  Future<CloudNote> createOrGetExistingNote(BuildContext context) async {
    final widgetNote = context.getArgument<CloudNote>();
    if (widgetNote != null) {
      _notes = widgetNote;
      _textcontroller.text = widgetNote.text;
      return widgetNote;
    }

    final existingNote = _notes;
    if (existingNote != null) {
      return existingNote;
    }
    final currentUser = AuthService.firebase().currentUser!;
    final userId = currentUser.id;
    final newNote = await _notesService.createNewNote(ownerUserID: userId);
    _notes = newNote;
    return newNote;
  }

  void _deleteNoteifTextisEmpty() {
    final note = _notes;
    if (_textcontroller.text.isEmpty && note != null) {
      _notesService.deleteNote(documentID: note.documentID);
    }
  }

  void _saveNoteifTextisNotEmpty() async {
    final note = _notes;
    final text = _textcontroller.text;
    if (text.isNotEmpty && note != null) {
      await _notesService.UpdateNote(
        documentID: note.documentID,
        text: text,
      );
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
    final bool isListening;
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Notes View'),
        actions: [
          IconButton(
              onPressed: (() async {
                final text = _textcontroller.text;
                if (_notes == null || text.isEmpty) {
                  await showCannotShareEmptyNoteDialog(context);
                } else {
                  Share.share(text);
                }
              }),
              icon: const Icon(Icons.share))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _listen,
        child: Icon(_isListening ? Icons.mic : Icons.mic_none),
      ),
      body: FutureBuilder(
        future: createOrGetExistingNote(context),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              _setuptextcontrollerListener();
              return Scaffold(
                body: TextField(
                  controller: _textcontroller,
                  keyboardType: TextInputType.multiline,
                  maxLines: max(0, 30),
                  decoration: const InputDecoration(
                    hintText: 'Write Your Note Here',
                    border: UnderlineInputBorder(),
                  ),
                ),
              );

            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
          onStatus: (val) => print('onStatus: $val'),
          onError: (val) => print('onError: $val'));
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _textcontroller.text = val.recognizedWords;
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }
}
