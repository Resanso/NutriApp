import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/auth_controller.dart';

class LoginController extends GetxController {
  final AuthController authC = Get.find<AuthController>();

  final emailC = TextEditingController();
  final passC = TextEditingController();

  @override
  void onClose() {
    emailC.dispose();
    passC.dispose();
    super.onClose();
  }

  void login() => authC.login(emailC.text, passC.text);
}
