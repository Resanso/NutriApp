/// Model untuk menyimpan data pengguna
///
/// Class ini digunakan untuk mengelola data pengguna seperti id, email, dan nama
class UserModel {
  /// ID unik pengguna
  String? id;

  /// Alamat email pengguna
  String? email;

  /// Nama lengkap pengguna
  String? name;

  /// Constructor untuk membuat instance UserModel
  ///
  /// Parameter bersifat opsional dan dapat bernilai null
  UserModel({this.id, this.email, this.name});

  /// Membuat instance UserModel dari data JSON
  ///
  /// [json] - Map yang berisi data pengguna dalam format JSON
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      UserModel(id: json['id'], email: json['email'], name: json['name']);

  /// Mengkonversi data UserModel menjadi format JSON
  ///
  /// Mengembalikan Map yang berisi data pengguna
  Map<String, dynamic> toJson() => {'id': id, 'email': email, 'name': name};
}
