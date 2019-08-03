import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/sign_in/email_sign_in_bloc.dart';
import 'package:time_tracker_flutter_course/app/sign_in/email_sign_in_model.dart';
import 'package:time_tracker_flutter_course/app/sign_in/validators.dart';
import 'package:time_tracker_flutter_course/common_widgets/form_submit_button.dart';
import 'package:time_tracker_flutter_course/common_widgets/platform_alert_dialog.dart';

class EmailSignInFormBlocBased extends StatefulWidget with EmailAndPasswordValidators {
  EmailSignInFormBlocBased({@required this.bloc});
  final EmailSignInBloc bloc;

  @override
  _EmailSignInFormBlocBasedState createState() =>
      _EmailSignInFormBlocBasedState();
}

class _EmailSignInFormBlocBasedState extends State<EmailSignInFormBlocBased> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();

  final FocusNode _passwordFocusNode = FocusNode();

  Future<void> _submit(BuildContext context) async {
    try {
      await widget.bloc.submit();
      Navigator.of(context).pop();
    } catch (e) {
      print(e.toString());
      PlatformAlertDialog(
        title: 'Sign in failed',
        content: e.toString(),
        defaultActionText: 'OK',
      ).show(context);
    }
  }

  void _toggleFormType() {
    widget.bloc.toggleFormType();
    _emailController.clear();
    _passwordController.clear();
  }

  List<Widget> _buildChildren(BuildContext context, EmailSignInModel model) {
    final primaryText = model.formType == EmailSignInFormType.signIn
        ? "Sign in"
        : 'Create an account';
    final secondaryText = model.formType == EmailSignInFormType.register
        ? 'Need an account? Register'
        : 'Have an account? Sign in';
    bool submitEnabled = widget.emailValidator.isValid(model.email) &&
        widget.passwordValidator.isValid(model.password) &&
        !model.isLoading;

    return [
      _buildEmailTextField(context, model),
      SizedBox(
        height: 8.0,
      ),
      _buildPasswordTextField(context, model),
      SizedBox(
        height: 8.0,
      ),
      FormSubmitButton(
        text: primaryText,
        onPressed: submitEnabled ? () => _submit(context) : null,
        isLoading: model.isLoading,
      ),
      SizedBox(
        height: 8.0,
      ),
      FlatButton(
        child: Text(secondaryText),
        onPressed: !model.isLoading ? _toggleFormType : null,
      ),
    ];
  }

  TextField _buildEmailTextField(BuildContext context, EmailSignInModel model) {
    bool showErrorText =
        model.submitted && !widget.emailValidator.isValid(model.email);
    return TextField(
      controller: _emailController,
      focusNode: _emailFocusNode,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'test@test.com',
        errorText: showErrorText ? widget.emptyEmail : null,
        enabled: model.isLoading == false,
      ),
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onChanged:  widget.bloc.updateEmail,
      onEditingComplete: () => _emailEditingComplete(context, model),
    );
  }

  TextField _buildPasswordTextField(
      BuildContext context, EmailSignInModel model) {
    bool showErrorText =
        model.submitted && !widget.passwordValidator.isValid(model.password);
    return TextField(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      decoration: InputDecoration(
        labelText: 'Password',
        errorText: showErrorText ? widget.emptyPassword : null,
        enabled: model.isLoading == false,
      ),
      obscureText: true,
      textInputAction: TextInputAction.done,
      onChanged: widget.bloc.updatePassword,
      onEditingComplete: () => _submit(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<EmailSignInModel>(
      stream: widget.bloc.modelStream,
      initialData: EmailSignInModel(),
      builder: (context, snapshot) {
        final EmailSignInModel model = snapshot.data;
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: _buildChildren(context, model),
          ),
        );
      },
    );
  }

  void _emailEditingComplete(BuildContext context, EmailSignInModel model) {
    final newFocus = widget.emailValidator.isValid(model.email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }
}
