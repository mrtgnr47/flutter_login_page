import 'package:firebase_app/screens/new_page.dart';
import 'package:firebase_app/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginRegisterPage extends StatefulWidget {
  const LoginRegisterPage({super.key});

  @override
  State<LoginRegisterPage> createState() => _LoginRegisterPageState();
}

class _LoginRegisterPageState extends State<LoginRegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLogin = true;
  String? errorMessage;

  Future<void> createUser() async {
    try {
      await Auth().createUser(
          email: emailController.text, password: passwordController.text);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> signIn() async {
    try {
      await Auth().singIn(
        email: emailController.text,
        password: passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: "E-mail",
                border: OutlineInputBorder(),
              ),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: "Password",
                border: OutlineInputBorder(),
              ),
            ),
            errorMessage != null ? Text(errorMessage!) : SizedBox.shrink(),
            ElevatedButton(
              onPressed: () {
                if (isLogin) {
                  signIn();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewPage(
                        user: emailController.text,
                      ),
                    ), // NewPage'yi aç
                  );
                } else {
                  createUser();
                }
              },
              child: isLogin ? Text("Login") : Text("Register"),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  isLogin = !isLogin;
                });
              },
              child: Text("Henüz hesabın yok mu? Tıkla"),
            )
          ],
        ),
      ),
    );
  }
}
