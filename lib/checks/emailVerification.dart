import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class VerifyScreen extends StatefulWidget {
  @override
  _VerifyScreenState createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final currentUser = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SpinKitCubeGrid(
            color: Colors.blueGrey[900],
            size: 50.0,
          ),
          AlertDialog(
            title: Center(child: Text('Email Verification')),
            content: Container(
              height: 90,
              child: Center(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      'Verification link has been sent to ${currentUser.email}'),
                  SizedBox(
                    height: 22,
                  ),
                  Text(
                    'Note: After successful Verification , restart the app.',
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.red,
                    ),
                  ),
                ],
              )),
            ),
            actions: [
              FlatButton(
                child: Text(
                  "Close The App",
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () => SystemNavigator.pop(),
              ),
              FlatButton(
                child: Text("Send Link Again"),
                onPressed: () async =>
                    await currentUser.sendEmailVerification(),
              )
            ],
          ),
        ],
      ),
    );
  }
}
