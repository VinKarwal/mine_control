import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mine_control/components/cutom_button.dart';
import 'package:mine_control/components/my_tile.dart';
import 'package:mine_control/components/text_field.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final userController = TextEditingController();
  final passController = TextEditingController();

  void signInUser() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: userController.text,
        password: passController.text,
      );
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      showErrorMessage(e.code);
    } catch (e) {
      Navigator.pop(context);
      showErrorMessage(e.toString());
    } finally {
      Navigator.pop(context);
    }
  }

  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.purple,
          title: Center(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("lib/assets/back_register.png"),
                fit: BoxFit.cover, // Align the image to the bottom
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
              child: Container(
                color: Colors.white.withOpacity(0.5),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('lib/assets/bitcoin-mining.png',
                            height: 150),
                        // Icon(Icons.agriculture_rounded,
                        //     size: 125.0, color: Colors.grey[800]),
                        const SizedBox(height: 25.0),
                        Text('Welcome Back! You\'ve been missed!',
                            style: TextStyle(
                                fontSize: 17, color: Colors.grey[800])),
                        const SizedBox(height: 25.0),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: RegisterTextField(
                            controller: userController,
                            obscureText: false,
                            labelText: 'Email',
                            hintText: 'Enter email',
                            prefixIcon: Icons.email,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the email';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: RegisterTextField(
                            controller: passController,
                            obscureText: true,
                            labelText: 'Password',
                            hintText: 'Enter password',
                            prefixIcon: Icons.lock,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the password';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.only(right: 25.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text("Forgot Password?",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey[800])),
                            ],
                          ),
                        ),
                        const SizedBox(height: 25.0),
                        MyButton(
                          text: "Sign In",
                          ontap: signInUser,
                        ),
                        const SizedBox(height: 25.0),
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: Colors.grey[400],
                                thickness: 1.0,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                "or continue with",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(color: Colors.grey[800]),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: Colors.grey[400],
                                thickness: 1.0,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20.0),
                        MyTile(
                          image: "lib/assets/google.png",
                          company: "Google",
                        ),
                        const SizedBox(height: 10.0),
                        MyTile(
                          image: "lib/assets/microsoft.png",
                          company: "Microsoft",
                        ),
                        const SizedBox(height: 20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account?",
                              style: TextStyle(
                                  fontSize: 16, color: Colors.grey[800]),
                            ),
                            const SizedBox(width: 5.0),
                            GestureDetector(
                              onTap: widget.onTap,
                              child: Text(
                                " Sign Up",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.purple[800],
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
