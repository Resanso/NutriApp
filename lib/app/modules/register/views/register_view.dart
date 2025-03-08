// Import paket yang diperlukan
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../controllers/register_controller.dart';

/// Widget halaman registrasi yang menggunakan GetX Controller
class RegisterView extends GetView<RegisterController> {
  const RegisterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        // ScrollView untuk menghindari overflow saat keyboard muncul
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                // Animasi Lottie sebagai ilustrasi
                Center(
                  child: Lottie.asset(
                    'assets/lottie.json',
                    height: 180,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Create Account',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const Text(
                  'Sign up to get started',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 25),
                // TextField untuk input nama pengguna
                TextField(
                  controller: controller.nameC,
                  decoration: InputDecoration(
                    labelText: "Name",
                    hintText: "Enter your full name",
                    prefixIcon: const Icon(Icons.person),
                    filled: true,
                    fillColor: Colors.grey[100],
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                // TextField untuk input email pengguna
                TextField(
                  controller: controller.emailC,
                  decoration: InputDecoration(
                    labelText: "Email",
                    hintText: "Enter your email",
                    prefixIcon: const Icon(Icons.email),
                    filled: true,
                    fillColor: Colors.grey[100],
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                // TextField untuk input password dengan mode tersembunyi
                TextField(
                  controller: controller.passC,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                    hintText: "Enter your password",
                    prefixIcon: const Icon(Icons.lock),
                    filled: true,
                    fillColor: Colors.grey[100],
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                // Tombol register dengan lebar penuh
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => controller.register(),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 1,
                    ),
                    child: const Text(
                      "Register",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                // Tombol untuk navigasi ke halaman login
                Center(
                  child: TextButton(
                    onPressed: () => Get.back(),
                    child: const Text("Already have an account? Login"),
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
