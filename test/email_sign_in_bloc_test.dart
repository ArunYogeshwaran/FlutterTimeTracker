import 'package:flutter_test/flutter_test.dart';
import 'package:time_tracker_flutter_course/app/sign_in/email_sign_in_bloc.dart';
import 'package:time_tracker_flutter_course/app/sign_in/email_sign_in_model.dart';

import 'mocks.dart';

void main() {
  MockAuth mockAuth;
  EmailSignInBloc bloc;

  setUp(() {
    mockAuth = MockAuth();
    bloc = EmailSignInBloc(auth: mockAuth);
  });

  tearDown(() {
    bloc.dispose();
  });

  test('stream emits correct events', () async {
    expect(
        bloc.modelStream,
        emitsInOrder([
          EmailSignInModel(),
          EmailSignInModel(email: 'test@email.com'),
          EmailSignInModel(
            email: 'test@email.com',
            password: 'password',
          ),
          EmailSignInModel(
            email: 'test@email.com',
            password: 'password',
            submitted: true,
            isLoading: true,
          ),
          EmailSignInModel(
            email: 'test@email.com',
            password: 'password',
            submitted: true,
            isLoading: false,
          ),
        ]));

    bloc.updateEmail('test@email.com');
    bloc.updatePassword('password');
    await bloc.submit();
  });
}
