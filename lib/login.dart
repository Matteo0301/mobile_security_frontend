import 'package:flutter/material.dart';
import 'package:mobile_security/register.dart';
import 'package:mobile_security/requests.dart';
import 'package:mobile_security/sqlite.dart';
import 'package:mobile_security/tasks/main_page.dart';

class Login extends StatefulWidget {
  const Login({super.key, required this.title, required this.onThemeChanged});
  final String title;
  final VoidCallback onThemeChanged;

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: AutofillGroup(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 16,
                  ),
                  child: TextFormField(
                    autofillHints: const [AutofillHints.username],
                    controller: userController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Username',
                    ),
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Insert username';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 16,
                  ),
                  child: TextFormField(
                    autofillHints: const [AutofillHints.password],
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                    keyboardType: TextInputType.visiblePassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Insert password';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 16.0,
                  ),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          // request to the server
                          String username = userController.text;
                          String password = passwordController.text;

                          loginRequest(username, password)
                              .then((user) async {
                                openDB(username, password);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => HomePage(
                                          onThemeChanged: widget.onThemeChanged,
                                        ),
                                  ),
                                );
                              })
                              .onError((error, stackTrace) async {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(error.toString())),
                                );
                              });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Wrong login data')),
                          );
                        }
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text('Login', style: TextStyle(fontSize: 20)),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 16.0,
                  ),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => RegisterPage(
                                  title: widget.title,
                                  onThemeChanged: widget.onThemeChanged,
                                ),
                          ),
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text('Register', style: TextStyle(fontSize: 20)),
                      ),
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
