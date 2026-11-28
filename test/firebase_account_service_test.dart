import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focusnflow/auth/account_service.dart';
import 'package:focusnflow/auth/firebase_account_service.dart';

class StubUser extends Fake implements User {
  StubUser(this.uid, this.email);
  @override
  final String uid;
  @override
  final String? email;
}

class StubCredential extends Fake implements UserCredential {
  StubCredential(this.user);
  @override
  final User? user;
}

class StubAuth extends Fake implements FirebaseAuth {
  Stream<User?> users = Stream.value(null);
  bool signedOut = false;

  @override
  Stream<User?> authStateChanges() => users;

  @override
  Future<void> signOut() async {
    if (failureCode != null) {
      throw FirebaseAuthException(code: failureCode!);
    }
    signedOut = true;
  }

  int signInCalls = 0;
  int registrationCalls = 0;
  int resetCalls = 0;
  String? emailReceived;
  String? passwordReceived;
  String? failureCode;
  User? result = StubUser('test-uid', 'student@example.edu');

  @override
  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    registrationCalls++;
    emailReceived = email;
    passwordReceived = password;
    if (failureCode != null) {
      throw FirebaseAuthException(
        code: failureCode!,
        message: 'Private diagnostic',
      );
    }
    return StubCredential(result);
  }

  @override
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    signInCalls++;
    emailReceived = email;
    passwordReceived = password;
    if (failureCode != null) {
      throw FirebaseAuthException(
        code: failureCode!,
        message: 'Private diagnostic',
      );
    }
    return StubCredential(result);
  }

  @override
  Future<void> sendPasswordResetEmail({
    required String email,
    ActionCodeSettings? actionCodeSettings,
  }) async {
    resetCalls++;
    emailReceived = email;
    if (failureCode != null) {
      throw FirebaseAuthException(
        code: failureCode!,
        message: 'Private diagnostic',
      );
    }
  }
}

Matcher failure(String text) =>
    isA<AccountFailure>().having((e) => e.message, 'message', text);

void main() {
  test(
    'registration forwards six-character boundary and returns SDK identity',
    () async {
      final auth = StubAuth();
      final account = await FirebaseAccountService(auth)
          .register(' student@example.edu ', ' six  ');
      expect(auth.registrationCalls, 1);
      expect(auth.emailReceived, 'student@example.edu');
      expect(auth.passwordReceived, ' six  ');
      expect(account.uid, 'test-uid');
    },
  );

  test('invalid registration input never reaches SDK', () async {
    final auth = StubAuth();
    final service = FirebaseAccountService(auth);
    await expectLater(
      service.register('bad', 'secret'),
      throwsA(isA<AccountFailure>()),
    );
    await expectLater(
      service.register('a@b.edu', 'short'),
      throwsA(isA<AccountFailure>()),
    );
    expect(auth.registrationCalls, 0);
  });

  test(
    'registration maps duplicate, weak password and network failures',
    () async {
      final auth = StubAuth();
      for (final code in [
        'email-already-in-use',
        'weak-password',
        'network-request-failed',
      ]) {
        auth.failureCode = code;
        await expectLater(
          FirebaseAccountService(auth).register('a@b.edu', 'secret'),
          throwsA(failure(FirebaseAccountService.messageFor(code))),
        );
      }
    },
  );

  test('registration refuses missing identity', () async {
    final auth = StubAuth()..result = null;
    await expectLater(
      FirebaseAccountService(auth).register('a@b.edu', 'secret'),
      throwsA(isA<AccountFailure>()),
    );
  });
  test('SDK session events map restored user and signed-out state', () async {
    final auth = StubAuth()
      ..users = Stream.fromIterable([StubUser('restored', 'a@b.edu'), null]);
    final events = await FirebaseAccountService(auth).watchAccount().toList();
    expect(events.first?.uid, 'restored');
    expect(events.last, isNull);
  });

  test('empty session UID fails rather than creating an account', () async {
    final auth = StubAuth()..users = Stream.value(StubUser('', 'a@b.edu'));
    await expectLater(
      FirebaseAccountService(auth).watchAccount(),
      emitsError(isA<AccountFailure>()),
    );
  });

  test('SDK sign-out completes or maps its failure', () async {
    final auth = StubAuth();
    final service = FirebaseAccountService(auth);
    await service.signOut();
    expect(auth.signedOut, isTrue);
    auth.failureCode = 'network-request-failed';
    await expectLater(
      service.signOut(),
      throwsA(failure('Check your connection and try again.')),
    );
  });
  test(
    'adapter sends trimmed email, unchanged password and returns SDK identity',
    () async {
      final auth = StubAuth();
      final account = await FirebaseAccountService(auth)
          .signIn(' student@example.edu ', ' password ');
      expect(auth.emailReceived, 'student@example.edu');
      expect(auth.passwordReceived, ' password ');
      expect(account.uid, 'test-uid');
      expect(account.email, 'student@example.edu');
    },
  );

  test('invalid local input never reaches either SDK request', () async {
    final auth = StubAuth();
    final service = FirebaseAccountService(auth);
    await expectLater(
      service.signIn('bad', 'secret'),
      throwsA(isA<AccountFailure>()),
    );
    await expectLater(
      service.signIn('a@b.edu', ''),
      throwsA(isA<AccountFailure>()),
    );
    await expectLater(
      service.resetPassword('bad'),
      throwsA(isA<AccountFailure>()),
    );
    expect(auth.signInCalls, 0);
    expect(auth.resetCalls, 0);
  });

  test(
    'missing or empty SDK identity never creates a client account',
    () async {
      final auth = StubAuth();
      final service = FirebaseAccountService(auth);
      for (final user in [null, StubUser('', null)]) {
        auth.result = user;
        await expectLater(
          service.signIn('a@b.edu', 'secret'),
          throwsA(isA<AccountFailure>()),
        );
      }
    },
  );

  test(
    'credential and disabled-account errors share a neutral message',
    () async {
      final auth = StubAuth();
      final service = FirebaseAccountService(auth);
      for (final code in [
        'user-not-found',
        'wrong-password',
        'invalid-credential',
        'user-disabled',
      ]) {
        auth.failureCode = code;
        await expectLater(
          service.signIn('a@b.edu', 'secret'),
          throwsA(
            failure(FirebaseAccountService.messageFor('invalid-credential')),
          ),
        );
      }
    },
  );

  test(
    'network, throttling, setup and unknown failures use safe messages',
    () async {
      final auth = StubAuth();
      for (final code in [
        'network-request-failed',
        'too-many-requests',
        'operation-not-allowed',
        'invalid-email',
        'unknown-code',
      ]) {
        auth.failureCode = code;
        await expectLater(
          FirebaseAccountService(auth).signIn('a@b.edu', 'secret'),
          throwsA(failure(FirebaseAccountService.messageFor(code))),
        );
        expect(
          FirebaseAccountService.messageFor(code),
          isNot(contains('Private diagnostic')),
        );
      }
    },
  );

  test('reset forwards email and hides the missing-account response', () async {
    final auth = StubAuth();
    final service = FirebaseAccountService(auth);
    await service.resetPassword(' student@example.edu ');
    expect(auth.emailReceived, 'student@example.edu');
    auth.failureCode = 'user-not-found';
    await service.resetPassword('missing@example.edu');
    expect(auth.resetCalls, 2);
  });

  test('reset network failure is not reported as a successful send', () async {
    final auth = StubAuth()..failureCode = 'network-request-failed';
    await expectLater(
      FirebaseAccountService(auth).resetPassword('a@b.edu'),
      throwsA(failure('Check your connection and try again.')),
    );
  });
}
