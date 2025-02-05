import 'package:flutter/material.dart';
import 'package:mobile_security/requests.dart';
import 'package:mobile_security/tasks/main_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({
    super.key,
    required this.title,
    required this.onThemeChanged,
  });
  final String title;
  final VoidCallback onThemeChanged;

  @override
  RegisterState createState() => RegisterState();
}

class RegisterState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordCheckController = TextEditingController();

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
                    vertical: 16,
                  ),
                  child: TextFormField(
                    autofillHints: const [AutofillHints.password],
                    controller: passwordCheckController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Retype password',
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value != passwordController.text) {
                        return 'Passwords don\'t match';
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

                          registerRequest(username, password)
                              .then((user) async {
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
