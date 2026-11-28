import 'package:firebase_auth/firebase_auth.dart';

import 'account_service.dart';

class FirebaseAccountService implements SessionService, RegistrationService {
  const FirebaseAccountService(this.auth);

  final FirebaseAuth auth;

  @override
  Future<Account> register(String email, String password) async {
    final error = validateEmail(email) ?? validateNewPassword(password);
    if (error != null) throw AccountFailure(error);
    try {
      final credential = await auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = credential.user;
      if (user == null || user.uid.isEmpty) {
        throw const AccountFailure(
          'Account creation could not be confirmed. Try signing in.',
        );
      }
      return Account(uid: user.uid, email: user.email ?? email.trim());
    } on FirebaseAuthException catch (error) {
      throw AccountFailure(messageFor(error.code));
    }
  }

  @override
  Stream<Account?> watchAccount() => auth.authStateChanges().map((user) {
    if (user == null) return null;
    if (user.uid.isEmpty) {
      throw const AccountFailure('Account could not be verified.');
    }
    return Account(uid: user.uid, email: user.email ?? '');
  });

  @override
  Future<void> signOut() async {
    try {
      await auth.signOut();
    } on FirebaseAuthException catch (error) {
      throw AccountFailure(messageFor(error.code));
    }
  }

  @override
  Future<Account> signIn(String email, String password) async {
    final error = validateEmail(email) ?? validateSignInPassword(password);
    if (error != null) throw AccountFailure(error);
    try {
      final credential = await auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = credential.user;
      if (user == null || user.uid.isEmpty) {
        throw const AccountFailure(
          'Sign-in did not return an account. Try again.',
        );
      }
      return Account(uid: user.uid, email: user.email ?? email.trim());
    } on FirebaseAuthException catch (error) {
      throw AccountFailure(messageFor(error.code));
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    final error = validateEmail(email);
    if (error != null) throw AccountFailure(error);
    try {
      await auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (error) {
      if (error.code == 'user-not-found') return;
      throw AccountFailure(messageFor(error.code));
    }
  }

  static String messageFor(String code) => switch (code) {
    'email-already-in-use' => 'Could not create the account. Try signing in or resetting your password.',
    'weak-password' => 'Choose a stronger password.',
    'invalid-credential' ||
    'user-not-found' ||
    'wrong-password' ||
    'user-disabled' =>
      'We could not sign you in. Check your details or reset your password.',
    'invalid-email' => 'Enter a valid email address.',
    'too-many-requests' =>
      'Too many attempts. Wait a little before trying again.',
    'network-request-failed' => 'Check your connection and try again.',
    'operation-not-allowed' => 'This sign-in method is not available yet.',
    _ => 'Account services are unavailable. Try again.',
  };
}
