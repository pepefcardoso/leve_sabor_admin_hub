import 'package:leve_sabor_admin_hub/model/blog_post.dart';
import 'package:leve_sabor_admin_hub/utils/http.dart';
import 'package:leve_sabor_admin_hub/utils/http_exception.dart';

class BlogPostsService {
  final Http http;

  BlogPostsService({required this.http});

  Future<List<BlogPost>> index() async {
    final response = await http.getJson('/api/blog-posts');

    final List<dynamic>? data = response.data;

    if (data != null) {
      return data.map((dynamic json) => BlogPost.fromJson(json)).toList();
    } else {
      throw const HttpException('Erro desconhecido');
    }
  }

  Future<BlogPost> register(Map<String, dynamic> parameters) async {
    final response = await http.postJson('/api/blog-posts', dados: parameters);

    final dynamic data = response.data;

    if (data != null) {
      return BlogPost.fromJson(data);
    } else {
      throw const HttpException('Erro desconhecido');
    }
  }
}
