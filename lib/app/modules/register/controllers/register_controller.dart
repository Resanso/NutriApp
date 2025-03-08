import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/auth_controller.dart';

class RegisterController extends GetxController {
  final AuthController authC = Get.find<AuthController>();

  final emailC = TextEditingController();
  final passC = TextEditingController();
  final nameC = TextEditingController();

  @override
  void onClose() {
    emailC.dispose();
    passC.dispose();
    nameC.dispose();
    super.onClose();
  }

  void register() => authC.register(emailC.text, passC.text, nameC.text);
}
