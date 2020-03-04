import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../services/auth_service.dart';
import '../widgets/providerWidget.dart';

final primaryColor = Colors.blue;

enum AuthFormType { signin, signup, reset }

class Signup extends StatefulWidget {
  final AuthFormType authFormType;

  Signup({Key key, @required this.authFormType}) : super(key: key);

  @override
  _SignupState createState() => _SignupState(authFormType: this.authFormType);
}

class _SignupState extends State<Signup> {
  AuthFormType authFormType;
  _SignupState({this.authFormType});
  final formKey = GlobalKey<FormState>();
  String _email;
  String _password;
  String _name;

  void switchFormState(String state) {
    formKey.currentState.reset();
    if (state == "signup") {
      setState(() {
        authFormType = AuthFormType.signup;
      });
    } else {
      setState(() {
        authFormType = AuthFormType.signin;
      });
    }
  }

  void submit() async {
    final form = formKey.currentState;
    form.save();
    try {
      final auth = Provider.of(context).auth;
      if (authFormType == AuthFormType.signin) {
        String uid = await auth.signInWithEmailAndPassword(_email, _password);
        print("Signed in with ID $uid");
      } else if (authFormType == AuthFormType.reset) {
        await auth.sendPasswordResetEmail(_email);
        setState(() {
          authFormType = AuthFormType.signin;
        });
      } else {
        String uid =
            await auth.createUserWithEmailAndPassword(_email, _password, _name);
        print("Signed up with new ID $uid");
      }
      Navigator.of(context).pushReplacementNamed("/home");
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        color: primaryColor,
        height: _height,
        width: _width,
        child: SafeArea(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: _height * .05,
              ),
              buildHeaderText(),
              SizedBox(
                height: _height * .05,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: buildInputs() + buildButtons(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AutoSizeText buildHeaderText() {
    String _headerText;
    if (authFormType == AuthFormType.signup) {
      _headerText = "Create New Account";
    } else if (authFormType == AuthFormType.reset) {
      _headerText = "Reset Password";
    } else {
      _headerText = "Sign In";
    }

    return AutoSizeText(
      _headerText,
      maxLines: 1,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 35,
        color: Colors.white,
      ),
    );
  }

  InputDecoration buildSignUpInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      focusColor: Colors.white,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.white,
          width: 0.0,
        ),
      ),
      contentPadding: EdgeInsets.only(left: 14, bottom: 10, top: 10),
    );
  }

  List<Widget> buildInputs() {
    List<Widget> textFields = [];

    if (authFormType == AuthFormType.reset) {
      textFields.add(
        TextFormField(
          style: TextStyle(fontSize: 22),
          decoration: buildSignUpInputDecoration("Email"),
          onSaved: (value) {
            _email = value;
          },
        ),
      );

      textFields.add(SizedBox(height: 20));
      return textFields;
    }

    if (authFormType == AuthFormType.signup) {
      textFields.add(
        TextFormField(
          style: TextStyle(fontSize: 22),
          decoration: buildSignUpInputDecoration("Name"),
          onSaved: (value) {
            _name = value;
          },
        ),
      );

      textFields.add(SizedBox(height: 20));
    }
    textFields.add(
      TextFormField(
        style: TextStyle(fontSize: 22),
        decoration: buildSignUpInputDecoration("Email"),
        onSaved: (value) {
          _email = value;
        },
      ),
    );

    textFields.add(SizedBox(height: 20));

    textFields.add(
      TextFormField(
        style: TextStyle(fontSize: 22),
        decoration: buildSignUpInputDecoration("Password"),
        obscureText: true,
        onSaved: (value) {
          _password = value;
        },
      ),
    );

    textFields.add(SizedBox(height: MediaQuery.of(context).size.height * 0.3));

    return textFields;
  }

  List<Widget> buildButtons() {
    String _switchButtonText;
    String _newFormState;
    String _submitButtonText;
    bool _showForgotPassword = false;

    if (authFormType == AuthFormType.signin) {
      _switchButtonText = "Create Account";
      _newFormState = "signup";
      _submitButtonText = "Sign In";
      _showForgotPassword = true;
    } else if (authFormType == AuthFormType.reset) {
      _switchButtonText = "Return to Sign In";
      _newFormState = "signin";
      _submitButtonText = "Submit";
    } else {
      _switchButtonText = "Have an Account? Sign In";
      _newFormState = "signin";
      _submitButtonText = "Sign Up";
    }

    return [
      Container(
        width: MediaQuery.of(context).size.width * 0.70,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              _submitButtonText,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          onPressed: submit,
        ),
      ),
      showForgotPassword(_showForgotPassword),
      FlatButton(
        child: Text(
          _switchButtonText,
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {
          switchFormState(_newFormState);
        },
      )
    ];
  }

  Widget showForgotPassword(bool visible) {
    return Visibility(
      child: FlatButton(
        child: Text(
          "Forgot Password??",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        onPressed: () {
          setState(() {
            authFormType = AuthFormType.reset;
          });
        },
      ),
      visible: visible,
    );
  }
}
