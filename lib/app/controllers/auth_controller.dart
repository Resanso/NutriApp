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

  /// Method untuk melakukan login user
  /// [email] - Email yang digunakan untuk login
  /// [password] - Password yang digunakan untuk login
  ///
  /// Method ini akan:
  /// 1. Mencoba login menggunakan Firebase Auth
  /// 2. Jika berhasil, update data currentUser
  /// 3. Redirect ke halaman home
  /// 4. Jika gagal, tampilkan pesan error
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

  /// Method untuk mendaftarkan user baru
  /// [email] - Email yang akan didaftarkan
  /// [password] - Password untuk akun baru
  /// [name] - Nama user yang mendaftar
  ///
  /// Method ini akan:
  /// 1. Mencoba membuat akun baru di Firebase Auth
  /// 2. Jika berhasil, update data currentUser dengan info yang baru
  /// 3. Redirect ke halaman home
  /// 4. Jika gagal, tampilkan pesan error
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
