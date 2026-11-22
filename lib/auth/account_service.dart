class Account {
  const Account({required this.uid, required this.email});

  final String uid;
  final String email;
}

abstract interface class AccountService {
  Future<Account> signIn(String email, String password);
  Future<void> resetPassword(String email);
}

class AccountFailure implements Exception {
  const AccountFailure(this.message);

  final String message;
}

class UnconfiguredAccountService implements AccountService {
  const UnconfiguredAccountService();

  static const message =
      'Account services are not connected yet. No details were sent.';

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
