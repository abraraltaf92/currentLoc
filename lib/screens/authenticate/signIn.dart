import 'package:flutter/material.dart';
import 'package:ooptech/services/auth.dart';
import 'package:ooptech/constants/loading.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  String error = '';
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String rePassword = '';
  bool loading = false;
  bool _passwordVisible = true;
  final AuthService _auth = AuthService();

  String validatePassword(String value) {
    if (value.trim().isEmpty || value.length < 6 || value.length > 14) {
      return 'Minimum 6 & Maximum 14 Characters!!!';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).accentColor,
              elevation: 0,
              title: Text(
                "Sign in ",
                style: TextStyle(fontSize: 25.0, color: Colors.blueGrey[900]),
              ),
              centerTitle: false,
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
                      "Sign Up",
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
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                        labelStyle: TextStyle(
                          fontSize: 15.0,
                        ),
                        hintText: 'Enter you email address',
                      ),
                      validator: (val) => val.isEmpty ? 'Enter an email' : null,
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
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                        labelStyle: TextStyle(
                          fontSize: 15.0,
                        ),
                        suffixIcon: IconButton(
                            icon: Icon(_passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            }),
                        hintText: 'Enter Your Password',
                      ),
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
                    RaisedButton(
                      color: Theme.of(context).accentColor,
                      child: Text(
                        "Sign In",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          setState(() {
                            loading = true;
                          });
                          dynamic userCredential = await _auth
                              .signInWithEmailAndPassword(email, password);
                          print(userCredential);
                          if (userCredential == null) {
                            setState(() {
                              loading = false;
                              error =
                                  'could not sign in with those credentials';
                            });
                          }
                        }
                      },
                    ),
                    SizedBox(
                      height: 12.0,
                    ),
                    Text(
                      error,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 14.0,
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
