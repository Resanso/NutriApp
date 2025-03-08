import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: controller.emailC,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: controller.passC,
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => controller.login(),
              child: const Text("Login"),
            ),
            TextButton(
              onPressed: () => Get.toNamed('/register'),
              child: const Text("Register"),
            ),
          ],
        ),
      ),
    );
  }
}
