
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hirdey_mittal/service/auth/auth_exceptions.dart';
import 'package:hirdey_mittal/service/auth/auth_provider.dart';
import 'package:hirdey_mittal/service/auth/auth_user.dart';

void main() {
  group('Mock Authentication' , () {
    final provider = MockAuthProvider();
    test('Should not be initialized to begin with', (){
      expect(provider.isInitialized, false);
    });

    test('Cannot log out if not initialized', (){
      expect(
        provider.logOut(),
        throwsA(const TypeMatcher<NotInitializedException>()),
      );
    });
    test('Should be able to be intialized', () async {
      await provider.initialise();
      expect(provider.isInitialized, true);
    });
    test('User should be null after initialization', (){
      expect(provider.currentUser, null);
    });
    test('Should be able to initialize in less than 2seconds', () async {
      await provider.initialise();
      expect(provider.isInitialized, true);
    }, timeout: const Timeout(Duration(seconds: 2)),
    );
    test('Create User should delegate to login function', () async {
    final badEmailUser = provider.createUser(email: 'foo@bar.com', password: 'anypassword');
     expect(badEmailUser,throwsA(const TypeMatcher<UserNotFoundAuthException>()));
      final badPasswordUser = provider.createUser(
        email: 'someone@bar.com',
        password: 'foobar',
      );
      expect(badPasswordUser,
          throwsA(const TypeMatcher<WrongPasswordAuthException>()));

      final user = await provider.createUser(
        email: 'foo',
        password: 'bar',
      );
      expect(provider.currentUser, user);
      expect(user.isEmailVerified, false);
    });
  test('Logged In user should be verified', (){
    provider.sendEmailVerification();
    final user = provider.currentUser;
    expect(user, isNotNull);
    expect(user!.isEmailVerified, true);

  });

  test('Should be Able to Log OUt And Log in', () async {
    await provider.logOut();
    await provider.logIn(email: 'email', password: 'password');
    final user = provider.currentUser;
    expect(user, isNotNull);
  });
  });
}
class NotInitializedException implements Exception{}


class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isInitialized = false;
  bool get isInitialized => _isInitialized; 
  @override
  Future<AuthUser> createUser({required String email, required String password, }) async {
      if (!isInitialized) throw NotInitializedException();
    await Future.delayed(const Duration(seconds: 1));
    return logIn(
      email: email,
      password: password,
    );
  }
  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialise() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<AuthUser> logIn({required String email, required String password}) {
    if(!isInitialized)throw NotInitializedException();
    if(email == 'foo@bar.com') throw UserNotFoundAuthException();
    if(password == 'foobar') throw WrongPasswordAuthException();
    const user = AuthUser(isEmailVerified: false,id: 'my_id', email: 'foo@bar.com');
    _user = user ;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if(!isInitialized) throw NotInitializedException();
    if(_user == null) throw UserNotFoundAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) throw NotInitializedException();
    final user = _user;
    if(user == null) throw UserNotFoundAuthException();
    const newUser = AuthUser(isEmailVerified: true, id:'my_id',email: 'foo@bar.com');
    _user = newUser;
  }
  
}