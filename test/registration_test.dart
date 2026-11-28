import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focusnflow/auth/account_service.dart';
import 'package:focusnflow/auth/sign_in_page.dart';

class TestRegistration implements RegistrationService {
  int calls = 0;
  final pending = Completer<Account>();
  @override
  Future<Account> register(String email, String password) {
    calls++;
    return pending.future;
  }

  @override
  Future<Account> signIn(String email, String password) =>
      throw UnimplementedError();
  @override
  Future<void> resetPassword(String email) async {}
}

Future<void> startRegistration(
  WidgetTester tester,
  AccountService service,
) async {
  await tester.pumpWidget(MaterialApp(home: SignInPage(service: service)));
  await tester.tap(find.byKey(const Key('account-mode')));
  await tester.pumpAndSettle();
}

Future<void> fill(
  WidgetTester tester,
  String password,
  String confirmation,
) async {
  await tester.enterText(
    find.byKey(const Key('account-email')),
    'student@example.edu',
  );
  await tester.enterText(find.byKey(const Key('account-password')), password);
  await tester.enterText(
    find.byKey(const Key('account-confirmation')),
    confirmation,
  );
  await tester.ensureVisible(find.text('Create account'));
  await tester.pumpAndSettle();
}

void main() {
  test(
    'new-account password boundary leaves existing sign-in rules unchanged',
    () {
      expect(validateNewPassword('short'), isNotNull);
      expect(validateNewPassword('sixsix'), isNull);
      expect(validateNewPassword(''), isNotNull);
      expect(validateSignInPassword('short'), isNull);
    },
  );

  testWidgets('weak and mismatched passwords make no registration request', (
    tester,
  ) async {
    final service = TestRegistration();
    await startRegistration(tester, service);
    await fill(tester, 'short', 'short');
    await tester.tap(find.text('Create account'));
    await tester.pumpAndSettle();
    expect(find.text('Use at least six characters.'), findsOneWidget);
    await fill(tester, 'secret', 'different');
    await tester.tap(find.text('Create account'));
    await tester.pumpAndSettle();
    expect(find.text('Passwords must match.'), findsOneWidget);
    expect(service.calls, 0);
  });

  testWidgets(
    'pending registration locks actions and backend denial allows retry',
    (tester) async {
      final service = TestRegistration();
      await startRegistration(tester, service);
      await fill(tester, 'secret', 'secret');
      await tester.tap(find.text('Create account'));
      await tester.pump();
      expect(service.calls, 1);
      expect(
        tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNull,
      );
      expect(
        tester
            .widget<TextButton>(find.byKey(const Key('account-mode')))
            .onPressed,
        isNull,
      );
      service.pending.completeError(
        const AccountFailure('Registration unavailable.'),
      );
      await tester.pumpAndSettle();
      expect(find.text('Registration unavailable.'), findsOneWidget);
      expect(
        tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNotNull,
      );
    },
  );

  testWidgets('registration success returns service account to caller', (
    tester,
  ) async {
    final service = TestRegistration();
    Account? result;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () async {
              result = await Navigator.of(context).push<Account>(
                MaterialPageRoute(builder: (_) => SignInPage(service: service)),
              );
            },
            child: const Text('Open account'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Open account'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('account-mode')));
    await tester.pumpAndSettle();
    await fill(tester, 'secret', 'secret');
    await tester.tap(find.text('Create account'));
    await tester.pump();
    service.pending.complete(
      const Account(uid: 'test-only', email: 'student@example.edu'),
    );
    await tester.pumpAndSettle();
    expect(result?.uid, 'test-only');
    expect(find.byType(SignInPage), findsNothing);
  });

  testWidgets('switching account mode clears passwords', (tester) async {
    await startRegistration(tester, TestRegistration());
    await fill(tester, 'secret', 'secret');
    await tester.ensureVisible(find.byKey(const Key('account-mode')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('account-mode')));
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<TextFormField>(find.byKey(const Key('account-password')))
          .controller!
          .text,
      isEmpty,
    );
    expect(find.byKey(const Key('account-confirmation')), findsNothing);
  });

  testWidgets('unconfigured registration never reports an account created', (
    tester,
  ) async {
    await startRegistration(tester, const UnconfiguredAccountService());
    await fill(tester, 'secret', 'secret');
    await tester.tap(find.text('Create account'));
    await tester.pumpAndSettle();
    expect(find.text(UnconfiguredAccountService.message), findsOneWidget);
    expect(find.byType(SignInPage), findsOneWidget);
  });
}
