import 'package:flutter/material.dart';
import 'services/auth_service.dart';

import 'views/home.dart';
import 'views/signup.dart';
import 'widgets/providerWidget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider(
      auth: AuthService(),
      child: MaterialApp(
        title: 'Auth',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: HomeController(),
        routes: <String, WidgetBuilder>{
          '/signup': (BuildContext context) =>
              // Signup(authFormType: AuthFormType.signup),
              Signup(authFormType: AuthFormType.signup),
          '/signin': (BuildContext context) =>
              // Signup(authFormType: AuthFormType.signin),
              Signup(authFormType: AuthFormType.signin),
          '/home': (BuildContext context) => HomeController(),
        },
      ),
    );
  }
}

class HomeController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthService auth = Provider.of(context).auth;
    return StreamBuilder(
      stream: auth.onAuthStateChanged,
      builder: (context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final bool signedIn = snapshot.hasData;
          return signedIn ? Home() : Signup(authFormType: AuthFormType.signup);
        }
        return CircularProgressIndicator();
      },
    );
  }
}

