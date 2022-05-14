import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';
@immutable
class AuthUser {
  final String id;
  final String? email;
  final bool isEmailVerified ;
 const AuthUser({required this.isEmailVerified, required this.id, required this.email});
 factory AuthUser.fromFirebase(User user) => AuthUser(isEmailVerified: user.emailVerified, id: user.uid, email: user.email!);
}
