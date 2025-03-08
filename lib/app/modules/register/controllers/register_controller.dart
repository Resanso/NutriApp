import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/auth_controller.dart';

/// Controller untuk halaman registrasi
/// Menangani logika dan state management halaman register
class RegisterController extends GetxController {
  /// Instance dari AuthController untuk menangani autentikasi
  final AuthController authC = Get.find<AuthController>();

  /// Controller untuk input field email
  final emailC = TextEditingController();

  /// Controller untuk input field password
  final passC = TextEditingController();

  /// Controller untuk input field nama
  final nameC = TextEditingController();

  /// Membersihkan controller ketika widget dihapus
  /// untuk mencegah memory leak
  @override
  void onClose() {
    emailC.dispose();
    passC.dispose();
    nameC.dispose();
    super.onClose();
  }

  /// Method untuk melakukan registrasi user baru
  /// Memanggil method register dari AuthController
  void register() => authC.register(emailC.text, passC.text, nameC.text);
}
