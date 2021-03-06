import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:ooptech/checks/authenticate.dart';
import 'package:ooptech/screens/home.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  final currentUser = FirebaseAuth.instance.currentUser;
  Timer timer;
  @override
  void initState() {
    Permission.location.request();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    if (user == null) {
      return Authenticate();
    } else {
      return Home();
    }
  }
}
