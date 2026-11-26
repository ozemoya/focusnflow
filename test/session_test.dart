import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focusnflow/auth/account_service.dart';
import 'package:focusnflow/main.dart';

class TestSessions implements SessionService {
  final changes = StreamController<Account?>.broadcast();
  int signOutCalls = 0;
  final pendingSignOut = Completer<void>();

  @override
  Stream<Account?> watchAccount() => changes.stream;
  @override
  Future<void> signOut() {
    signOutCalls++;
    return pendingSignOut.future;
  }

  @override
  Future<Account> signIn(String email, String password) async =>
      const Account(uid: 'route-only', email: 'route@example.edu');
  @override
  Future<void> resetPassword(String email) async {}
}

Future<void> openProfile(WidgetTester tester) async {
  await tester.tap(find.byKey(const Key('tab-Profile')));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets(
    'changing session source hides the previous account while waiting',
    (tester) async {
      final first = TestSessions();
      final second = TestSessions();
      addTearDown(first.changes.close);
      addTearDown(second.changes.close);
      await tester.pumpWidget(FocusNFlowApp(service: first));
      await openProfile(tester);
      first.changes.add(
        const Account(uid: 'first', email: 'first@example.edu'),
      );
      await tester.pumpAndSettle();
      await tester.pumpWidget(FocusNFlowApp(service: second));
      await tester.pumpAndSettle();
      expect(find.text('first@example.edu'), findsNothing);
      expect(find.text('Checking account…'), findsOneWidget);
      expect(find.text('Sign out'), findsNothing);
    },
  );

  testWidgets('restored identity and signed-out changes drive Profile', (
    tester,
  ) async {
    final service = TestSessions();
    addTearDown(service.changes.close);
    await tester.pumpWidget(FocusNFlowApp(service: service));
    await openProfile(tester);
    expect(find.text('Checking account…'), findsOneWidget);
    expect(find.text('Sign out'), findsNothing);
    service.changes.add(
      const Account(uid: 'test', email: 'restored@example.edu'),
    );
    await tester.pumpAndSettle();
    expect(find.text('restored@example.edu'), findsOneWidget);
    expect(find.text('Sign out'), findsOneWidget);
    service.changes.add(null);
    await tester.pumpAndSettle();
    expect(find.text('Not signed in'), findsOneWidget);
    expect(find.text('restored@example.edu'), findsNothing);
    expect(find.text('Sign out'), findsNothing);
  });

  testWidgets('stream failure clears previously displayed identity', (
    tester,
  ) async {
    final service = TestSessions();
    addTearDown(service.changes.close);
    await tester.pumpWidget(FocusNFlowApp(service: service));
    await openProfile(tester);
    service.changes.add(
      const Account(uid: 'test', email: 'private@example.edu'),
    );
    await tester.pumpAndSettle();
    service.changes.addError(Exception('private diagnostics'));
    await tester.pumpAndSettle();
    expect(find.text('private@example.edu'), findsNothing);
    expect(find.text('Account unavailable'), findsOneWidget);
    expect(find.text('Sign out'), findsNothing);
    expect(find.textContaining('private diagnostics'), findsNothing);
  });

  testWidgets('pending and failed sign-out do not invent a signed-out state', (
    tester,
  ) async {
    final service = TestSessions();
    addTearDown(service.changes.close);
    await tester.pumpWidget(FocusNFlowApp(service: service));
    await openProfile(tester);
    service.changes.add(
      const Account(uid: 'test', email: 'signed-in@example.edu'),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sign out'));
    await tester.pump();
    expect(service.signOutCalls, 1);
    expect(find.text('Signing out…'), findsOneWidget);
    service.pendingSignOut.completeError(Exception('offline'));
    await tester.pumpAndSettle();
    expect(find.text('signed-in@example.edu'), findsOneWidget);
    expect(find.text('Could not sign out. Try again.'), findsOneWidget);
  });

  testWidgets('startup failure is visible and prevents account entry', (
    tester,
  ) async {
    await tester.pumpWidget(
      const FocusNFlowApp(startupMessage: 'Account startup failed.'),
    );
    await openProfile(tester);
    expect(find.text('Account startup failed.'), findsOneWidget);
    await tester.tap(find.text('Account & courses'));
    await tester.pumpAndSettle();
    expect(find.text('Account startup failed.'), findsOneWidget);
  });

  testWidgets('a route result cannot create an authenticated Profile', (
    tester,
  ) async {
    final service = TestSessions();
    addTearDown(service.changes.close);
    await tester.pumpWidget(FocusNFlowApp(service: service));
    service.changes.add(null);
    await tester.pumpAndSettle();
    await openProfile(tester);
    await tester.tap(find.text('Account & courses'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('account-email')),
      'route@example.edu',
    );
    await tester.enterText(
      find.byKey(const Key('account-password')),
      'example',
    );
    await tester.tap(find.text('Sign in'));
    await tester.pumpAndSettle();
    expect(find.text('Not signed in'), findsOneWidget);
    expect(find.text('route@example.edu'), findsNothing);
  });
}
