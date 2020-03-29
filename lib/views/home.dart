import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/auth_service.dart';
import '../widgets/providerWidget.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
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
      body: Container(
        width: _width,
        height: _height * 0.7,
        margin: const EdgeInsets.all(30.0),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          border: Border.all(width: 3.0),
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          ),
        ), //       <--- BoxDecoration here
        child: Center(
          child: Text(
            "text",
            style: TextStyle(fontSize: 30.0),
          ),
        ),
      ),
    );
  }
}
