// ignore_for_file: unused_import

import 'package:flutter/cupertino.dart';
import 'package:hirdey_mittal/service/crud/crud_crudexceptions.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;


class noteService {
  Database? _db;

  Future<DatabaseNotes> updateNote({required DatabaseNotes note,required String text}) async {
    final db = _getDatabaseOrThrow();
    await getNote(id: note.id);
    final updatesCount = await db.update(noteTable, {
      textColumn: text,
      isSyncedWithCloudColumn: 0,
    });

    if(updatesCount == 0){
      throw CouldNotUpdateNotes();
    }
    else{
      return await getNote(id: note.id);
    }
  } 

  Future<Iterable<DatabaseNotes>> getAllNotes() async {
    final db = _getDatabaseOrThrow();
    final notes = await db.query(noteTable);
    return notes.map((noteRow) => DatabaseNotes.fromRow(noteRow));
  }

  Future<DatabaseNotes> getNote({required int id}) async {
    final db = _getDatabaseOrThrow();
    final notes = await db.query(noteTable, limit: 1, where: 'id = ?', whereArgs: [id]);
    if(notes.isEmpty){
      throw couldNotFindNote();
    }
    else{
      return DatabaseNotes.fromRow(notes.first);
    }
  } 

  Future<int> deleteAllNote() async {
    final db = _getDatabaseOrThrow();
    return await db.delete(noteTable);
  }

  Future<void> deleteNote({required int id}) async {
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(noteTable, where: 'id = ?', whereArgs: [id]);
    if(deletedCount == 0){
      throw CouldNotDeleteNote();
    }
  }

  Future<DatabaseNotes> createNote({required DatabaseUser owner}) async {
  final db = _getDatabaseOrThrow();
  // check for the user exists
  final dbUser = await getUser(email: owner.email);
  if (dbUser!=owner){
    throw CouldNotFindUser();
  }
  const text = '';
  // create the notes
  final noteID = await db.insert(noteTable, {
    useridColumn: owner.id,
    textColumn : text,
    isSyncedWithCloudColumn: 1,
  });
  final note = DatabaseNotes(id: noteID, userId: owner.id, text: text, isSyncedWithCloud: true);
  return note;
  }

  Future<DatabaseUser> getUser({required String email}) async {
    final db = _getDatabaseOrThrow();
    final results = await db.query(userTable, limit: 1, where: 'email =?', whereArgs: [email.toLowerCase()]);
    if(results.isEmpty){
      throw CouldNotFindUser();
    }
    else{
      return DatabaseUser.fromRow(results.first);
    }

  }

  Future<DatabaseUser> createUser ({required String email}) async{
    final db = _getDatabaseOrThrow();
    final results = await db.query(userTable, limit: 1, where: 'email =?', whereArgs: [email.toLowerCase()]);
    if(results.isNotEmpty) {
      throw UserAlreadyExists();
    }
    final userID = await db.insert(userTable, {
      emailColumn: email.toLowerCase()
    });
    return DatabaseUser(id:userID, email: email);
  }

  Future<void> deleteUser({required String email}) async{
    final db = _getDatabaseOrThrow();
    final deletedCount = db.delete(userTable, where: 'email =?', whereArgs: [email.toLowerCase()]);
    if (deletedCount != 1){
      throw CouldNotDeleteUser();
    }
  }

  Database _getDatabaseOrThrow() {
    final db = _db;
    if(db ==null){
      throw DatabaseIsNotOpen();
    } else {
      return db;
    }
  }

  Future<void> open() async {
    if(_db != null){
      throw databaseAlreadyOpenException();
    }
    try{
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbName);
      final db = await openDatabase(dbPath);
      _db = db;
      // create user table
      
      await db.execute(createUserTable);
      // create note table
      await db.execute(createNoteTable);
    } on MissingPlatformDirectoryException {
      throw unableToGetDocumentsDirectory();
    }
  }

  Future<void> close() async {
    final db  = _db;
    if (db == null){
      throw DatabaseIsNotOpen();
    }
    else {
      await db.close();
      _db = null;
    }
  }
}  
@immutable
class DatabaseUser {
  final int id;
  final String email;
  const DatabaseUser({required this.id,required this.email});

  DatabaseUser.fromRow(Map<String, Object?> map)
  : id = map[idColumn] as int , 
  email = map[emailColumn] as String;

  @override
  String toString() => 'Person, ID = $id, email = $email';

  @override
  bool operator == (covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}
class DatabaseNotes {
  final int id;
  final int userId;
  final String text;
  final bool isSyncedWithCloud;

  DatabaseNotes({required this.id,required this.userId,required this.text,required this.isSyncedWithCloud});
  DatabaseNotes.fromRow(Map<String, Object?> map)
  : id = map[idColumn] as int,
  userId = map[useridColumn] as int,
  text = map[textColumn] as String,
  isSyncedWithCloud = map[isSyncedWithCloudColumn] as int == 1 ? true : false;


  @override
  String toString() => 'Note, ID =$id, userId = $userId, isSyncedWithCloud = $isSyncedWithCloud, text = "" ';
  @override
  bool operator == (covariant DatabaseNotes other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

const dbName = 'notes.db';
const noteTable = 'note';
const userTable = 'user';
const textColumn = 'text';
const isSyncedWithCloudColumn = 'is_synced_with_cloud';
const useridColumn = 'user_id';
const idColumn = 'id';
const emailColumn = 'email';
const createUserTable = '''CREATE TABLE IF NOT EXISTS "user" (
    	"id"	INTEGER NOT NULL,
    	"email"	TEXT NOT NULL UNIQUE,
    	PRIMARY KEY("id" AUTOINCREMENT)
);''';
const createNoteTable = ''' CREATE TABLE IF NOT EXISTS "note" (
	    "id"	INTEGER NOT NULL,
	    "user_id"	INTEGER NOT NULL,
	    "text"	TEXT,
	    "is_synced_with_cloud"	INTEGER DEFAULT 0,
    	PRIMARY KEY("id" AUTOINCREMENT),
	    FOREIGN KEY("user_id") REFERENCES "user"("id")
);''';