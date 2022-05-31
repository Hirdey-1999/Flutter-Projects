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
      throw CouldNotUpdateNotes();
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
          .then((value) => value.docs.map((doc) {
                return CloudNote(
                    documentID: doc.id,
                    ownerUserID: doc.data()[ownerUserIdFieldName] as String,
                    text: doc.data()[textFieldName]);
              }));
    } catch (e) {
      throw couldNotGetAllNotesException();
    }
  }

  void createNewNote({required String ownerUserID}) async {
    await notes.add({ownerUserIdFieldName: ownerUserID, textFieldName: ''});
  }

  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared;
}
