import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:time_tracker_flutter_course/app/sign_in/sign_in_manager.dart';

import 'mocks.dart';


/*
This class is created to track the list of all values
* */
class MockValueNotifier<T> extends ValueNotifier<T> {
  MockValueNotifier(T value) : super(value);

  List<T> values = [];

  @override
  set value(T newValue) {
    values.add(newValue);
    super.value = newValue;
  }
}

void main() {
  MockAuth mockAuth;
  MockValueNotifier<bool> isLoading;
  SignInManager signInManager;
  
  setUp(() {
    mockAuth = MockAuth();
    isLoading = MockValueNotifier<bool>(false);
    signInManager = SignInManager(auth: mockAuth, isLoading: isLoading);
  });
  
  test('sign in', () async {
    await signInManager.signInAnonymously();

    expect(isLoading.values, [true, false]);
  });

}