import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/sign_in/email_sign_in_form_stateful.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

class MockAuth extends Mock implements AuthBase {}

void main() {
  MockAuth mockAuth;

  setUp(() {
    mockAuth = MockAuth();
  });

  Future<void> pumpEmailSignInForm(WidgetTester tester,
      {VoidCallback onSignedIn}) async {
    await tester.pumpWidget(
      Provider<AuthBase>(
        builder: (_) => mockAuth,
        child: MaterialApp(
          home: Scaffold(body: EmailSignInFormStateful(
            onSignedIn: onSignedIn,
          )),
        ),
      ),
    );
  }

  group('sign in', () {
    testWidgets('sign in email password in never called',
        (WidgetTester tester) async {
      var signedIn = false;
      await pumpEmailSignInForm(tester, onSignedIn: () => signedIn = true);

      final signInButton = find.text('Sign in');
      await tester.tap(signInButton);
      verifyNever(mockAuth.signInWithEmailAndPassword(any, any));
      expect(signedIn, false);
    });

    testWidgets('sign in email password called', (WidgetTester tester) async {
      var signedIn = false;
      await pumpEmailSignInForm(tester, onSignedIn: () => signedIn = true);

      const email = 'email@email.com';
      const password = 'password';
      final emailField = find.byKey(Key('email_signin'));
      expect(emailField, findsOneWidget);
      await tester.enterText(emailField, email);

      final passwordField = find.byKey(Key('password_signin'));
      expect(passwordField, findsOneWidget);
      await tester.enterText(passwordField, password);

      // When running tests, wigdets are not rebuilt when setState is called
      await tester.pump();

      final signInButton = find.text('Sign in');
      await tester.tap(signInButton);

      verify(mockAuth.signInWithEmailAndPassword(email, password)).called(1);
      expect(signedIn, true);
    });
  });

  group('register', () {
    testWidgets('toggle to reg mode', (WidgetTester tester) async {
      await pumpEmailSignInForm(tester);

      final registerButton = find.text('Need an account? Register');
      await tester.tap(registerButton);

      await tester.pump();

      final createAccountButton = find.text('Create an account');
      expect(createAccountButton, findsOneWidget);
    });

    testWidgets('sign in email password called', (WidgetTester tester) async {
      await pumpEmailSignInForm(tester);

      const email = 'email@email.com';
      const password = 'password';

      final registerButton = find.text('Need an account? Register');
      await tester.tap(registerButton);
      await tester.pump();

      final emailField = find.byKey(Key('email_signin'));
      expect(emailField, findsOneWidget);
      await tester.enterText(emailField, email);

      final passwordField = find.byKey(Key('password_signin'));
      expect(passwordField, findsOneWidget);
      await tester.enterText(passwordField, password);

      // When running tests, wigdets are not rebuilt when setState is called
      await tester.pump();

      final signInButton = find.text('Sign in');
      await tester.tap(signInButton);

      verify(mockAuth.signInWithEmailAndPassword(email, password)).called(1);
    });

    testWidgets('register with email password called',
        (WidgetTester tester) async {
      await pumpEmailSignInForm(tester);

      const email = 'email@email.com';
      const password = 'password';
      final emailField = find.byKey(Key('email_signin'));
      expect(emailField, findsOneWidget);
      await tester.enterText(emailField, email);

      final passwordField = find.byKey(Key('password_signin'));
      expect(passwordField, findsOneWidget);
      await tester.enterText(passwordField, password);

      // When running tests, wigdets are not rebuilt when setState is called
      await tester.pump();

      final createAccountButton = find.text('Create an account');
      expect(createAccountButton, findsOneWidget);
      await tester.tap(createAccountButton);

      verify(mockAuth.createUserWithEmailAndPassword(email, password))
          .called(1);
    });
  });
}
