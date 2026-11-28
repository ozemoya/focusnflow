class Account {
  const Account({required this.uid, required this.email});

  final String uid;
  final String email;
}

abstract interface class AccountService {
  Future<Account> signIn(String email, String password);
  Future<void> resetPassword(String email);
}

abstract interface class SessionService implements AccountService {
  Stream<Account?> watchAccount();
  Future<void> signOut();
}

abstract interface class RegistrationService implements AccountService {
  Future<Account> register(String email, String password);
}

class AccountFailure implements Exception {
  const AccountFailure(this.message);

  final String message;
}

class UnconfiguredAccountService
    implements SessionService, RegistrationService {
  const UnconfiguredAccountService();

  static const message =
      'Account services are not connected yet. No details were sent.';

  @override
  Stream<Account?> watchAccount() => Stream.value(null);

  @override
  Future<void> signOut() async {}

  @override
  Future<Account> register(String email, String password) async {
    throw const AccountFailure(message);
  }

  @override
  Future<Account> signIn(String email, String password) async {
    throw const AccountFailure(message);
  }

  @override
  Future<void> resetPassword(String email) async {
    throw const AccountFailure(message);
  }
}

String? validateEmail(String? value) {
  final email = value?.trim() ?? '';
  if (email.isEmpty) return 'Enter your email address.';
  if (email.length > 254 ||
      !RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email)) {
    return 'Enter a valid email address.';
  }
  return null;
}

String? validateSignInPassword(String? value) {
  return value == null || value.isEmpty ? 'Enter your password.' : null;
}

String? validateNewPassword(String? value) {
  if (value == null || value.isEmpty) return 'Enter a password.';
  if (value.length < 6) return 'Use at least six characters.';
  return null;
}
