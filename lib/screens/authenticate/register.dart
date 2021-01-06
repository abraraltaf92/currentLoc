import 'package:flutter/material.dart';
import 'package:ooptech/services/auth.dart';
import 'package:ooptech/constants/loading.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({this.toggleView});
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String rePassword = '';
  String error_1 = '';
  String error_2 = '';
  bool _passwordVisible = true;
  bool loading = false;
  final _emailIdController = TextEditingController(text: '');
  final _passwordController = TextEditingController(text: '');
  final _confirmPasswordController = TextEditingController(text: '');
  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (value.isEmpty || !regex.hasMatch(value))
      return 'Enter Valid Email Id!!!';
    else
      return null;
  }

  String validatePassword(String value) {
    if (value.trim().isEmpty || value.length < 6 || value.length > 14) {
      return 'Minimum 6 & Maximum 14 Characters!!!';
    }
    return null;
  }

  String validateConfirmPassword(String value) {
    if (value.trim() != _passwordController.text.trim()) {
      return 'Password Mismatch!!!';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            resizeToAvoidBottomPadding: false,
            appBar: AppBar(
              backgroundColor: Theme.of(context).accentColor,
              elevation: 0,
              title: Text(
                "Create Account",
                style: TextStyle(fontSize: 25.0, color: Colors.blueGrey[900]),
              ),
              actions: <Widget>[
                FlatButton.icon(
                    onPressed: () {
                      widget.toggleView();
                    },
                    icon: Icon(
                      Icons.person,
                      color: Colors.blueGrey[100],
                    ),
                    label: Text(
                      "Sign In",
                      style: TextStyle(color: Colors.blueGrey[100]),
                    ))
              ],
            ),
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).accentColor,
                  ],
                ),
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "OopTech",
                    style: TextStyle(
                        fontFamily: 'Signatra',
                        fontSize: 90.0,
                        color: Colors.blueGrey[800]),
                  ),
                  Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            controller: _emailIdController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Email',
                              labelStyle: TextStyle(
                                fontSize: 15.0,
                              ),
                              hintText: 'Enter you email address',
                            ),
                            validator: validateEmail,
                            onChanged: (val) {
                              setState(() {
                                email = val;
                              });
                            },
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          TextFormField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Password',
                                labelStyle: TextStyle(
                                  fontSize: 15.0,
                                ),
                                hintText: 'Enter Your Password',
                                suffixIcon: IconButton(
                                  icon: Icon(_passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                  onPressed: () {
                                    setState(() {
                                      _passwordVisible = !_passwordVisible;
                                    });
                                  },
                                )),
                            validator: validatePassword,
                            obscureText: _passwordVisible,
                            onChanged: (val) {
                              setState(() {
                                password = val;
                              });
                            },
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          TextFormField(
                            controller: _confirmPasswordController,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Re-Password',
                                labelStyle: TextStyle(
                                  fontSize: 15.0,
                                ),
                                hintText: 'Renter Your Password ',
                                suffixIcon: IconButton(
                                  icon: Icon(_passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                  onPressed: () {
                                    setState(() {
                                      _passwordVisible = !_passwordVisible;
                                    });
                                  },
                                )),
                            validator: (val) => val != password
                                ? "Password doesn't match"
                                : null,
                            obscureText: _passwordVisible,
                            onChanged: (val) {
                              setState(() {
                                rePassword = val;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  RaisedButton(
                    color: Theme.of(context).accentColor,
                    child: Text(
                      "Create My Account",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        setState(() {
                          loading = true;
                        });
                        dynamic userCredential = await _auth
                            .registerWithEmailAndPassword(email, password);
                        print('ye le : $userCredential');
                        if (userCredential == null) {
                          setState(() {
                            loading = false;
                            error_1 =
                                'could not sign up with these credentials';
                          });
                        }
                      }
                    },
                  ),
                  SizedBox(
                    height: 12.0,
                  ),
                  Text(
                    error_1,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 14.0,
                    ),
                  ),
                  Text(
                    "OR",
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: () async {
                      setState(() {
                        loading = true;
                      });
                      dynamic user = await _auth.signInWithGoogle();

                      if (user == null) {
                        setState(() {
                          loading = false;
                          error_2 = ' Google Authentication failed! ';
                        });
                      }
                    },
                    child: Container(
                      width: 260.0,
                      height: 60.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                              'assets/images/google_signin_button.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    error_2,
                    style: TextStyle(color: Colors.red, fontSize: 14.0),
                  ),
                ],
              ),
            ),
          );
  }
}
