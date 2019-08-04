import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/home_page.dart';
import 'package:time_tracker_flutter_course/app/sign_in/sign_in_bloc.dart';
import 'package:time_tracker_flutter_course/app/sign_in/sign_in_page.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);
    return StreamBuilder<User>(
        stream: auth.onAuthStateChanged,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            User user = snapshot.data;
            if (user == null) {
              return _buildSignInPage();
            }
            return HomePage();
          } else {
            return Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
        });
  }

  Widget _buildSignInPage() {
    final signInBloc = SignInBloc();
    return StatefulProvider<SignInBloc>(
      valueBuilder: (context) => signInBloc,
      onDispose: (context, bloc) => bloc.dispose(),
      child: SignInPage(bloc: SignInBloc(),),
    );
  }
}
