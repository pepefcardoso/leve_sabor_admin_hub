class User {
  final int? id;
  final String? name;
  final String? email;
  final DateTime? birthday;
  final String? phone;
  final String? cpf;
  final String? profilePicUrl;

  const User({
    this.id,
    this.name,
    this.email,
    this.birthday,
    this.phone,
    this.cpf,
    this.profilePicUrl,
  });

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        email = json['email'],
        birthday = json['birthday'] != null ? DateTime.parse(json['birthday']) : null,
        phone = json['phone'],
        cpf = json['cpf'],
        profilePicUrl = json['profile_pic_url'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'birthday': birthday?.toIso8601String(),
    'phone': phone,
    'cpf': cpf,
    'profile_pic_url': profilePicUrl,
  };
}
