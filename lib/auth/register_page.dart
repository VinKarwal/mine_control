import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mine_control/components/cutom_button.dart';
import 'package:mine_control/components/my_tile.dart';
import 'package:mine_control/components/text_field.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final userController = TextEditingController();
  final passController = TextEditingController();
  final confirmPassController = TextEditingController();

  void signUp() async {
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      if (passController.text == confirmPassController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: userController.text,
          password: passController.text,
        );
        Navigator.pop(context);
      } else if (passController.text != confirmPassController.text) {
        Navigator.pop(context);
        showErrorMessage("Passwords do not match");
      } else if (passController.text.length < 6) {
        Navigator.pop(context);
        showErrorMessage("Password must be at least 6 characters");
      } else {
        Navigator.pop(context);
        showErrorMessage("Please enter a valid email and password");
      }
    } on FirebaseAuthException catch (e) {
      showErrorMessage(e.code);
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
              style: TextStyle(color: Colors.white),
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
                        Image.asset(
                          'lib/assets/working.png',
                          height: 150,
                        ),
                        // Icon(Icons.person_rounded,
                        //     size: 125.0, color: Colors.grey[800]),
                        const SizedBox(height: 25.0),
                        Text('Let\'s create an account for you!',
                            style: TextStyle(
                                fontSize: 17, color: Colors.grey[800])),
                        const SizedBox(height: 25.0),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: RegisterTextField(
                            controller: userController,
                            obscureText: false,
                            labelText: 'Email',
                            hintText: 'Enter Email',
                            prefixIcon: Icons.email_rounded,
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
                            hintText: 'Enter Password',
                            prefixIcon: Icons.password_rounded,
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
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: RegisterTextField(
                            controller: confirmPassController,
                            obscureText: true,
                            labelText: 'Confirm Password',
                            hintText: 'Confirm Password',
                            prefixIcon: Icons.password_rounded,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the password';
                              }
                              return null;
                            },
                          ),
                        ),
                        // const SizedBox(height: 10),
                        // Padding(
                        //   padding: const EdgeInsets.only(right: 25.0),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.end,
                        //     children: [
                        //       Text(
                        //         "Forgot Password?",
                        //         style: Theme.of(context)
                        //             .textTheme
                        //             .headlineSmall!
                        //             .copyWith(
                        //               color: Colors.grey[800],
                        //             ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        const SizedBox(height: 20.0),
                        MyButton(
                          text: "Sign Up",
                          ontap: signUp,
                        ),
                        const SizedBox(height: 20.0),
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
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Text(
                                "or continue with",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.grey[800]),
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
                        const SizedBox(height: 25.0),
                        MyTile(
                          image: "lib/assets/google.png",
                          company: "Google",
                        ),
                        const SizedBox(height: 10.0),
                        MyTile(
                          image: "lib/assets/microsoft.png",
                          company: "Microsoft",
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account?",
                              style: TextStyle(
                                  fontSize: 16, color: Colors.grey[800]),
                            ),
                            const SizedBox(width: 7.0),
                            GestureDetector(
                              onTap: widget.onTap,
                              child: Text(
                                " Sign In",
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
