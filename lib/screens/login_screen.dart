import 'package:arcitech/screens/registration_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/firebase_controller.dart';
import '../utils/validators.dart';

class LoginScreen extends StatelessWidget {
  final FirebaseController firebaseController = Get.put(FirebaseController());
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: TextInputType.emailAddress,
                cursorColor: Colors.black,
                validator: (input) =>
                    input?.isValidEmail() ?? true ? null : "Check your email",
                controller: emailController,
                textInputAction: TextInputAction.search,
                decoration: const InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red)),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue)),
                  disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue)),
                  hintText: 'Enter Email ID',
                  hintStyle: TextStyle(color: Colors.black),
                ),
                style: const TextStyle(color: Colors.black),
              ),
            ),
            const SizedBox(
              height: 12.0,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (input) => input?.isValidPassword() ?? true
                    ? null
                    : "Please enter valid password",
                keyboardType: TextInputType.visiblePassword,
                cursorColor: Colors.black,
                controller: passwordController,
                obscureText: true,
                textInputAction: TextInputAction.search,
                decoration: const InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red)),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue)),
                  disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue)),
                  hintText: 'Enter Password',
                  hintStyle: TextStyle(color: Colors.black),
                ),
                style: const TextStyle(color: Colors.black),
              ),
            ),
            const SizedBox(height: 12.0),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState?.validate() ?? false) {
                  ///Logins the user
                  await firebaseController.loginUser(
                      email: emailController.text,
                      password: passwordController.text);
                } else {
                  Get.snackbar("Error", "Please check the entered details");
                }
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.blue, // foreground
              ),
              child: const Text("Login"),
            ),
            const SizedBox(height: 12.0),
            const Text("OR"),
            const SizedBox(height: 12.0),
            InkWell(
                onTap: () => Get.to(() => RegistrationScreen()),
                child: const Text(
                  "Register",
                  style: TextStyle(color: Colors.blue, fontSize: 18.0),
                )),
          ],
        ),
      ),
    );
  }
}
// extension EmailValidator on String {
//   bool isValidEmail() {
//     return RegExp(
//         r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
//         .hasMatch(this);
//   }
