import 'package:leve_sabor_admin_hub/enum/blog_post_status_enum.dart';
import 'package:leve_sabor_admin_hub/model/blog_post_category.dart';
import 'package:leve_sabor_admin_hub/model/blog_post_image.dart';

class BlogPost {
  final int? id;
  final String? title;
  final String? description;
  final String? content;
  final BlogPostStatusEnum? status;
  final int? userId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<BlogPostCategory>? categories;
  final BlogPostImage? image;

  BlogPost({
    this.id,
    this.title,
    this.description,
    this.content,
    this.image,
    this.status,
    this.categories,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  BlogPost.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        description = json['description'],
        content = json['content'],
        image = json['blog_post_image'] != null ? BlogPostImage.fromJson(json['blog_post_image']) : null,
        status = json['status'] != null ? BlogPostStatusEnum.values.firstWhere((element) => element.value == json['status']) : null,
        categories = json['categories'] != null ? (json['categories'] as List).map((tag) => BlogPostCategory.fromJson(tag)).toList() : null,
        userId = json['user_id'],
        createdAt = json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
        updatedAt = json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null;
}
