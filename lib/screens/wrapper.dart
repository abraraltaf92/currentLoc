import 'package:ooptech/screens/authenticate/authenticate.dart';
import 'package:ooptech/screens/home.dart';
import 'package:ooptech/modals/user.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  void initState() {
    super.initState();
    Permission.location.request();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<TheUser>(context);

    if (user == null) {
      return Authenticate();
    } else {
      return Home();
    }
  }
}
