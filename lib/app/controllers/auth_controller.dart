import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../models/user_model.dart';

class AuthController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;

  Stream<User?> get streamAuthStatus => auth.authStateChanges();

  var currentUser = UserModel().obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize user state from Firebase Auth
    auth.authStateChanges().listen((User? user) {
      if (user != null) {
        currentUser.value = UserModel(
          id: user.uid,
          email: user.email,
          name: user.displayName,
        );
      } else {
        currentUser.value = UserModel();
      }
    });
  }

  Future<void> login(String email, String password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      currentUser.value = UserModel(
        id: userCredential.user!.uid,
        email: userCredential.user!.email,
      );
      Get.offAllNamed('/home');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> register(String email, String password, String name) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      currentUser.value = UserModel(
        id: userCredential.user!.uid,
        email: userCredential.user!.email,
        name: name,
      );

      Get.offAllNamed('/home');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  void logout() async {
    await auth.signOut();
    Get.offAllNamed('/login');
  }
}
