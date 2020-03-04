import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../widgets/providerWidget.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
              try {
                AuthService auth = Provider.of(context).auth;
                await auth.signOut();
              } catch (e) {
                print(e);
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Text("Logged IN"),
      ),
    );
  }
}
