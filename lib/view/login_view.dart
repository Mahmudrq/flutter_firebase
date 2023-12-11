import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("LOGIN"),
          centerTitle: true,
          backgroundColor: Colors.teal,
        ),
        body: FutureBuilder(
          future: Firebase.initializeApp(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return Column(
                  children: [
                    TextField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      decoration:
                          const InputDecoration(hintText: "Enter Your email"),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: _password,
                      autocorrect: false,
                      obscureText: true,
                      enableSuggestions: false,
                      decoration:
                          InputDecoration(hintText: "Enter Your passowrd"),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextButton(
                      onPressed: () async {
                        final email = _email.text;
                        final password = _password.text;
                        try {
                          final userCredential = await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                            email: email,
                            password: password,
                          );
                          print(userCredential);
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'User-Not-Found') {
                            print('User Not Found');
                          } else if (e.code == 'wrong-password') {
                            print('Wrong Password');
                          }
                        }
                      },
                      child: const Text('Log In'),
                    ),
                  ],
                );
              default:
                return const Text("Loading....");
            }
          },
        ),
      ),
    );
  }
}
