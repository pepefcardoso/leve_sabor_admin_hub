class UserImage {
  final int? id;
  final String? name;
  final String? path;
  final int? userId;
  final String? url;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserImage({
    this.id,
    this.name,
    this.path,
    this.userId,
    this.url,
    this.createdAt,
    this.updatedAt,
  });

  UserImage.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        path = json['path'],
        userId = json['user_id'],
        url = json['url'],
        createdAt = json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
        updatedAt = json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null;
}
