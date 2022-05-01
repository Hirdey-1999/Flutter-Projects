import 'dart:html';

import 'package:hirdey_mittal/service/auth/auth_user.dart';
import 'package:hirdey_mittal/service/auth/auth_exceptions.dart';
import 'package:hirdey_mittal/service/auth/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart' 
 show FirebaseAuth,FirebaseAuthException;

 class FirebaseAuthProvider implements AuthProvider{
  @override
  Future<AuthUser> createUser ({required String email, required String password,}) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,

      );
      final user = currentUser;
      if(user!= null){
        return user;
      }
      else{
        throw UserNotLoggedInAuthExcepton();
      }
    } on FirebaseAuthException catch(e){
      if(e.code == 'weak-password'){
        throw WeakPasswordAuthExcepton();
      }
     else if(e.code=='email-already-in-use'){ 
       throw EmailAlreadyInUseAuthExcepton();
    }
      else if(e.code == 'invalid-email'){
        throw InvalidEmailAuthExcepton();
      }
      else {
        throw GenericAuthExcepton();
     }
    } catch(_){
      throw GenericAuthExcepton();
    }
  }
  @override
  // TODO: implement currentUser
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null){
      return AuthUser.fromFirebase(user);
    }
    else{
      return null;
    }
  }
  @override
  Future<AuthUser?> logIn({required String email, required String password}) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      final user = currentUser;
      if(user!= null){
        return user;
      }
      else{
        throw UserNotLoggedInAuthExcepton();
      }
    }on FirebaseAuthException catch(e) {
      if (e.code == 'user-not-found') {
        throw UserNotFoundAuthException();
      }
      else if(e.code == 'wrong-password'){
        throw WrongPasswordAuthException();
      }
      else {
        throw GenericAuthExcepton();
      }
    }catch (e) {
      throw GenericAuthExcepton();
    }
    catch (_){
      throw  GenericAuthExcepton();
    }
    
  }

  @override
  Future<void> logOut() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null){
     await FirebaseAuth.instance.signOut();
    } else {
      throw UserNotLoggedInAuthExcepton();
    }
  }

  @override
  Future<void> sendEmailVerification() async{
    final user = FirebaseAuth.instance.currentUser;
    if(user != null){
      await user.sendEmailVerification();
    }
    else{
      throw UserNotLoggedInAuthExcepton();
    }
  }
}