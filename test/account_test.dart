import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focusnflow/auth/account_service.dart';
import 'package:focusnflow/auth/sign_in_page.dart';

class TestAccountService implements AccountService {
  int signInCalls = 0;
  int resetCalls = 0;
  String? receivedEmail;
  String? receivedPassword;
  final pending = Completer<Account>();

  @override
  Future<Account> signIn(String email, String password) {
    signInCalls++;
    receivedEmail = email;
    receivedPassword = password;
    return pending.future;
  }

  @override
  Future<void> resetPassword(String email) async {
    resetCalls++;
    receivedEmail = email;
  }
}

void main() {
  testWidgets('successful service result returns the account to its caller', (
    tester,
  ) async {
    final service = TestAccountService();
    Account? result;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            return TextButton(
              onPressed: () async {
                result = await Navigator.of(context).push<Account>(
                  MaterialPageRoute(
                    builder: (_) => SignInPage(service: service),
                  ),
                );
              },
              child: const Text('Open account'),
            );
          },
        ),
      ),
    );
    await tester.tap(find.text('Open account'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('account-email')),
      'student@example.edu',
    );
    await tester.enterText(
      find.byKey(const Key('account-password')),
      'example',
    );
    await tester.tap(find.text('Sign in'));
    await tester.pump();
    service.pending.complete(
      const Account(uid: 'test-only', email: 'student@example.edu'),
    );
    await tester.pumpAndSettle();
    expect(result?.uid, 'test-only');
    expect(find.byType(SignInPage), findsNothing);
  });

  testWidgets('unexpected service failures do not reveal raw errors', (
    tester,
  ) async {
    final service = TestAccountService();
    await tester.pumpWidget(MaterialApp(home: SignInPage(service: service)));
    await tester.enterText(
      find.byKey(const Key('account-email')),
      'student@example.edu',
    );
    await tester.enterText(
      find.byKey(const Key('account-password')),
      'example',
    );
    await tester.tap(find.text('Sign in'));
    await tester.pump();
    service.pending.completeError(Exception('private diagnostic detail'));
    await tester.pumpAndSettle();
    expect(
      find.text('We could not reach account services. Try again.'),
      findsOneWidget,
    );
    expect(find.textContaining('private diagnostic'), findsNothing);
  });

  test('email boundaries and existing passwords are validated locally', () {
    for (final value in [null, '', ' ', 'student', 'a@@b.com', 'a b@c.edu']) {
      expect(validateEmail(value), isNotNull);
    }
    expect(validateEmail(' student@example.edu '), isNull);
    expect(validateEmail('${'a' * 250}@b.edu'), isNotNull);
    expect(validateSignInPassword(''), isNotNull);
    expect(validateSignInPassword(null), isNotNull);
    expect(validateSignInPassword('short'), isNull);
    expect(validateSignInPassword(' password '), isNull);
  });

  testWidgets('invalid credentials never call the account service', (
    tester,
  ) async {
    final service = TestAccountService();
    await tester.pumpWidget(MaterialApp(home: SignInPage(service: service)));
    await tester.tap(find.text('Sign in'));
    await tester.pump();
    expect(find.text('Enter your email address.'), findsOneWidget);
    expect(find.text('Enter your password.'), findsOneWidget);
    expect(service.signInCalls, 0);
    await tester.tap(find.text('Reset password'));
    await tester.pump();
    expect(service.resetCalls, 0);
  });

  testWidgets('pending sign-in prevents duplicates and denial allows retry', (
    tester,
  ) async {
    final service = TestAccountService();
    await tester.pumpWidget(MaterialApp(home: SignInPage(service: service)));
    await tester.enterText(
      find.byKey(const Key('account-email')),
      ' student@example.edu ',
    );
    await tester.enterText(
      find.byKey(const Key('account-password')),
      ' password ',
    );
    await tester.tap(find.text('Sign in'));
    await tester.pump();
    expect(service.signInCalls, 1);
    expect(service.receivedEmail, 'student@example.edu');
    expect(service.receivedPassword, ' password ');
    expect(
      tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
      isNull,
    );
    expect(
      tester.widget<TextButton>(find.byType(TextButton)).onPressed,
      isNull,
    );
    service.pending.completeError(const AccountFailure('Sign-in was denied.'));
    await tester.pumpAndSettle();
    expect(find.text('Sign-in was denied.'), findsOneWidget);
    expect(
      tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
      isNotNull,
    );
  });

  testWidgets(
    'reset does not require a password or disclose account existence',
    (tester) async {
      final service = TestAccountService();
      await tester.pumpWidget(MaterialApp(home: SignInPage(service: service)));
      await tester.enterText(
        find.byKey(const Key('account-email')),
        'student@example.edu',
      );
      await tester.tap(find.text('Reset password'));
      await tester.pumpAndSettle();
      expect(service.resetCalls, 1);
      expect(service.signInCalls, 0);
      expect(
        find.textContaining('If this address has an account'),
        findsOneWidget,
      );
    },
  );

  testWidgets('unconfigured production service never invents a session', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: SignInPage()));
    await tester.enterText(
      find.byKey(const Key('account-email')),
      'student@example.edu',
    );
    await tester.enterText(
      find.byKey(const Key('account-password')),
      'example',
    );
    await tester.tap(find.text('Sign in'));
    await tester.pumpAndSettle();
    expect(find.text(UnconfiguredAccountService.message), findsOneWidget);
    expect(find.byType(SignInPage), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('leaving during a request does not update disposed state', (
    tester,
  ) async {
    final service = TestAccountService();
    await tester.pumpWidget(MaterialApp(home: SignInPage(service: service)));
    await tester.enterText(
      find.byKey(const Key('account-email')),
      'student@example.edu',
    );
    await tester.enterText(
      find.byKey(const Key('account-password')),
      'example',
    );
    await tester.tap(find.text('Sign in'));
    await tester.pump();
    await tester.pumpWidget(const MaterialApp(home: SizedBox()));
    service.pending.completeError(Exception('Disconnected'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
