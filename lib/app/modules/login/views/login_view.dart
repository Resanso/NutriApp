// Import package yang dibutuhkan untuk membangun UI login
// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../controllers/login_controller.dart';
import '../../../routes/app_pages.dart';

/// Widget LoginView untuk menampilkan halaman login
/// Widget ini menggunakan GetView untuk menghubungkan dengan LoginController
/// yang menangani logika login seperti autentikasi dan validasi input
class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Scaffold sebagai kerangka utama halaman
    return Scaffold(
      // SafeArea memastikan konten tidak tertutup oleh notch atau status bar
      body: SafeArea(
        // SingleChildScrollView memungkinkan konten di-scroll jika melebihi layar
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            // Column untuk menyusun widget secara vertikal
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                // Menampilkan animasi Lottie di bagian atas
                Center(
                  child: Lottie.asset(
                    'assets/lottie.json',
                    height: 180,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Welcome Back',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const Text(
                  'Sign in to continue',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 25),
                // TextField email dengan validasi input
                // controller.emailC menangani state input email
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
                // TextField password dengan fitur hide/show
                // controller.passC menangani state input password
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
                // Tombol login dengan handler controller.login()
                // Akan memvalidasi input dan melakukan proses autentikasi
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => controller.login(),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 1,
                    ),
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                // Tombol navigasi ke halaman registrasi
                // Menggunakan Get.toNamed untuk routing
                Center(
                  child: TextButton(
                    onPressed: () => Get.toNamed(Routes.REGISTER),
                    child: const Text("Don't have an account? Register"),
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
