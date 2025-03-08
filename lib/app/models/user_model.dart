class UserModel {
  String? id;
  String? email;
  String? name;

  UserModel({this.id, this.email, this.name});

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      UserModel(id: json['id'], email: json['email'], name: json['name']);

  Map<String, dynamic> toJson() => {'id': id, 'email': email, 'name': name};
}
