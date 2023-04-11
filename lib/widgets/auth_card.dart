import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/http_exception.dart ';
import '../providers/auth.dart';
import '../models/user.dart';

// ignore: constant_identifier_names
enum AuthMode { Signup, Login }

class AuthCard extends StatefulWidget {
  @override
  State<AuthCard> createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  // first mode that shows when opening the app
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
    'username': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();

  // error dialog
  void _showError(String message) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('An error occured !'),
              content: Text(message),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Okay'))
              ],
            ));
  }

  // sends the information to the provider (firebase)
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.Login) {
        // Log user in
        await Provider.of<Auth>(context, listen: false).login(
          _authData['email'] as String,
          _authData['password'] as String,
        );
      } else {
        // Sign user up
        await Provider.of<Auth>(context, listen: false).signUp(
          _authData['email'] as String,
          _authData['password'] as String,
          User(_authData['username'] as String, '', ''),
        );
      }
      // error handling ->
    } on HttpException catch (e) {
      var errorMessage = 'Could not authentificate you. Please try again later';
      if (e.message.contains('EMAIL_EXISTS')) {
        errorMessage = 'This email already exists !';
      } else if (e.message.contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address !';
      } else if (e.message.contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak.';
      } else if (e.message.contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email.';
      } else if (e.message.contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password !';
      }
      _showError(errorMessage);
    } catch (error) {
      const errorMessage =
          'Could not authentificate you. Please try again later';
      _showError(errorMessage);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // gets the size of the device for future use of UI
    final deviceSize = MediaQuery.of(context).size;
    // the AuthCard itself
    return Card(
      color: const Color.fromRGBO(252, 250, 250, 1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      // AnimatedContainer automatically changes between configurations
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.linear,
        height: _authMode == AuthMode.Signup ? 380 : 260,
        constraints:
            BoxConstraints(minHeight: _authMode == AuthMode.Signup ? 320 : 260),
        width: deviceSize.width * 0.75,
        padding: const EdgeInsets.all(16.0),
        // the information regarding the login / signup
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                // username
                if (_authMode == AuthMode.Signup)
                  TextFormField(
                    style: TextStyle(color: Theme.of(context).accentColor),
                    decoration: InputDecoration(
                      labelText: 'Username',
                      labelStyle:
                          TextStyle(color: Theme.of(context).accentColor),
                    ),
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      // verifies if the e-amil is valid
                      if (value!.isEmpty) {
                        return 'Please provide a username !';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _authData['username'] = value!;
                    },
                  ),
                // login e-mail TextFormField
                TextFormField(
                  style: TextStyle(color: Theme.of(context).accentColor),
                  decoration: InputDecoration(
                    labelText: 'E-Mail',
                    labelStyle: TextStyle(color: Theme.of(context).accentColor),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    // verifies if the e-amil is valid
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Invalid email !';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['email'] = value!;
                  },
                ),
                // login password TextFormField
                TextFormField(
                  style: TextStyle(color: Theme.of(context).accentColor),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Theme.of(context).accentColor),
                  ),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    // verifies if the password is valid (simple validation)
                    if (value!.isEmpty || value.length < 5) {
                      return 'Password is too short !';
                    }
                  },
                  onSaved: (value) {
                    _authData['password'] = value!;
                  },
                ),
                if (_authMode == AuthMode.Signup)
                  // adds a new TextFormField if the user needs to signup
                  TextFormField(
                    style: TextStyle(color: Theme.of(context).accentColor),
                    enabled: _authMode == AuthMode.Signup,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      labelStyle:
                          TextStyle(color: Theme.of(context).accentColor),
                    ),
                    obscureText: true,
                    validator: _authMode == AuthMode.Signup
                        ? (value) {
                            // verifies if the password entered is the same as verified password
                            if (value != _passwordController.text) {
                              return 'Passwords do not match !';
                            }
                          }
                        : null,
                  ),
                const SizedBox(
                  height: 20,
                ),
                // if the login/signup is loading, it shows a CircularProgressIndicator to the user
                if (_isLoading)
                  const CircularProgressIndicator()
                else
                  // the button for submitting the information
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25.0, vertical: 2),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).accentColor,
                        ),
                        onPressed: _submit,
                        child: Text(
                          _authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                // button to switch the auth mode (login / signup)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextButton(
                    onPressed: _switchAuthMode,
                    style: const ButtonStyle(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD',
                      style: TextStyle(color: Theme.of(context).accentColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
