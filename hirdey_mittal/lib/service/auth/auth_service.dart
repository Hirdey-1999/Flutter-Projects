import 'package:hirdey_mittal/service/auth/auth_provider.dart';
import 'package:hirdey_mittal/service/auth/auth_user.dart';
import 'package:hirdey_mittal/service/auth/firebase_Auth_Provider.dart';



class AuthService implements AuthProvider{
  final AuthProvider provider;
  const AuthService(this.provider);

  factory AuthService.firebase()=> AuthService(FirebaseAuthProvider(),);
  
  @override
  Future<AuthUser> createUser({required String email, required String password}) => provider.createUser(email: email, password: password);

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<AuthUser?> logIn({required String email, required String password}) => provider.logIn(email: email, password: password);

  @override
  Future<void> logOut() => provider.logOut();
  

  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();

  @override
  Future<void> initialise() => provider.initialise();
}