import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';
import 'firebase_options.dart';
import 'app/controllers/auth_controller.dart';
import 'app/constants/app_theme.dart';

/// Fungsi utama aplikasi yang dijalankan pertama kali
/// Melakukan inisialisasi Firebase dan controller autentikasi
void main() async {
  // Memastikan widget Flutter sudah terinisialisasi
  WidgetsFlutterBinding.ensureInitialized();

  // Menginisialisasi Firebase dengan konfigurasi default platform
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Mendaftarkan AuthController ke GetX untuk manajemen state
  Get.put(AuthController(), permanent: true);

  // Menjalankan aplikasi dengan widget MyApp
  runApp(const MyApp());
}

/// Widget utama aplikasi yang mengatur tema dan routing
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: AppTheme.theme, // Mengatur tema aplikasi
      title: "Nutri App", // Judul aplikasi
      debugShowCheckedModeBanner: false, // Menyembunyikan banner debug
      initialRoute: AppPages.INITIAL, // Rute awal aplikasi
      getPages: AppPages.routes, // Daftar rute aplikasi
    );
  }
}
