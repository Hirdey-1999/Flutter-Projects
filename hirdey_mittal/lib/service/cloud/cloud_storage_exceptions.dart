class cloudStorageException implements Exception{
  const cloudStorageException();
}
// C in CRUD
class couldNotCreateNoteException extends cloudStorageException{

}
// R in CRUD
class couldNotGetAllNotesException extends cloudStorageException{

}
// U in CRUD
class couldNotUpdateNoteException extends cloudStorageException{

}
// D in CRUD
class couldNotDeleteNoteException extends cloudStorageException{

}