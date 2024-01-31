import 'package:leve_sabor_admin_hub/model/user_image.dart';

class User {
  final int? id;
  final String? name;
  final String? email;
  final DateTime? birthday;
  final String? phone;
  final String? cpf;
  final UserImage? image;

  const User({
    this.id,
    this.name,
    this.email,
    this.birthday,
    this.phone,
    this.cpf,
    this.image,
  });

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        email = json['email'],
        birthday = json['birthday'] != null ? DateTime.parse(json['birthday']) : null,
        phone = json['phone'],
        cpf = json['cpf'],
        image = json['user_image'] != null ? UserImage.fromJson(json['user_image']) : null;

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'birthday': birthday?.toIso8601String(),
    'phone': phone,
    'cpf': cpf,
    'image': image,
  };

  String? get firstName => name?.split(' ')[0];
}
