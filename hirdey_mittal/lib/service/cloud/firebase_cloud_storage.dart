import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hirdey_mittal/service/cloud/cloud_storage_constants.dart';
import 'package:hirdey_mittal/service/crud/crud_crudexceptions.dart';
import 'cloud_note.dart';
import 'cloud_storage_exceptions.dart';

class FirebaseCloudStorage {
  final notes = FirebaseFirestore.instance.collection('notes');
  Future<void> deleteNote({required String documentID}) async {
    try {
      notes.doc(documentID).delete();
    } catch (e) {
      throw couldNotDeleteNoteException();
    }
  }

  Future<void> UpdateNote({
    required String documentID,
    required String text,
  }) async {
    try {
      notes.doc(documentID).update({textFieldName: text});
    } catch (e) {
      throw couldNotUpdateNoteException();
    }
  }

  Stream<Iterable<CloudNote>> allNotes({required String ownerUserID}) =>
      notes.snapshots().map((event) => event.docs
          .map((doc) => CloudNote.fromSnapshot(doc))
          .where((note) => note.ownerUserID == ownerUserID));

  Future<Iterable<CloudNote>> getNotes({required String ownerUserID}) async {
    try {
      return await notes
          .where(ownerUserIdFieldName, isEqualTo: ownerUserID)
          .get()
          .then(
              (value) => value.docs.map((doc) => CloudNote.fromSnapshot(doc)));
    } catch (e) {
      throw couldNotGetAllNotesException();
    }
  }

  Future<CloudNote> createNewNote({required String ownerUserID}) async {
    final document = await notes.add({
      ownerUserIdFieldName: ownerUserID,
      textFieldName: '',
    });
    final fetchednote = await document.get();
    return CloudNote(
      documentID: fetchednote.id,
      ownerUserID: ownerUserID,
      text: '',
    );
  }

  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared;
}
