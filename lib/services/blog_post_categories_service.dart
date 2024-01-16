import 'package:leve_sabor_admin_hub/model/blog_post_category.dart';
import 'package:leve_sabor_admin_hub/utils/http.dart';
import 'package:leve_sabor_admin_hub/utils/http_exception.dart';

class BlogPostCategoriesService {
  final Http http;

  BlogPostCategoriesService({required this.http});

  Future<List<BlogPostCategory>> index() async {
    final response = await http.getJson('/api/blog-post-category');

    final List<dynamic>? data = response.data;

    if (data != null) {
      return data
          .map((dynamic json) => BlogPostCategory.fromJson(json))
          .toList();
    } else {
      throw const HttpException('Erro desconhecido');
    }
  }
}
