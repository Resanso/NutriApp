import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/auth_controller.dart';

/// Controller untuk menangani logika halaman login
class LoginController extends GetxController {
  /// Instance dari AuthController untuk mengakses fungsi autentikasi
  final AuthController authC = Get.find<AuthController>();

  /// Controller untuk input field email
  final emailC = TextEditingController();

  /// Controller untuk input field password
  final passC = TextEditingController();

  /// Method yang dipanggil ketika controller dihapus
  /// Membersihkan controller untuk mencegah memory leak
  @override
  void onClose() {
    emailC.dispose();
    passC.dispose();
    super.onClose();
  }

  /// Method untuk melakukan proses login
  /// Memanggil fungsi login dari AuthController dengan parameter email dan password
  void login() => authC.login(emailC.text, passC.text);
}
