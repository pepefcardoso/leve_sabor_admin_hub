import 'dart:io';

import 'package:dio/dio.dart';
import 'package:leve_sabor_admin_hub/model/blog_post.dart';
import 'package:leve_sabor_admin_hub/utils/http.dart';
import 'package:leve_sabor_admin_hub/utils/http_exception.dart';

class BlogPostsService {
  final Http http;

  BlogPostsService({required this.http});

  Future<List<BlogPost>> index({Map<String, dynamic>? parameters}) async {
    final response = await http.getJson(
      '/api/blog-posts',
      queryParameters: parameters,
    );

    final List<dynamic>? data = response.data;

    if (data != null) {
      final List<BlogPost> blogPosts = data.map((dynamic json) => BlogPost.fromJson(json)).toList();

      return blogPosts;
    } else {
      throw const HttpException('Erro desconhecido');
    }
  }

  Future<BlogPost> register(Map<String, dynamic> parameters) async {
    final Map<String, dynamic> imageData = Map.from(parameters['image']);

    if (imageData['file'] != null) {
      final MultipartFile file = MultipartFile.fromBytes(
        (imageData['file']).readAsBytesSync(),
        filename: (imageData['file'] as File).path.split('/').last,
      );

      imageData['file'] = file;
    }

    parameters['image'] = imageData;

    final response = await http.postJson('/api/blog-posts', dados: FormData.fromMap(parameters, ListFormat.multiCompatible));

    final dynamic data = response.data;

    if (data != null) {
      return BlogPost.fromJson(data);
    } else {
      throw const HttpException('Erro desconhecido');
    }
  }

  Future<BlogPost> update(int id, Map<String, dynamic> parameters) async {
    final Map<String, dynamic> imageData = Map.from(parameters['image']);

    if (imageData['file'] != null) {
      final MultipartFile file = MultipartFile.fromBytes(
        (imageData['file']).readAsBytesSync(),
        filename: (imageData['file'] as File).path.split('/').last,
      );

      imageData['file'] = file;
    }

    parameters['image'] = imageData;

    parameters['_method'] = 'PUT';

    final response = await http.postJson('/api/blog-posts/$id', dados: FormData.fromMap(parameters, ListFormat.multiCompatible));

    final dynamic data = response.data;

    if (data != null) {
      return BlogPost.fromJson(data);
    } else {
      throw const HttpException('Erro desconhecido');
    }
  }

  Future<void> delete(int id) async {
    await http.deleteJson('/api/blog-posts/$id');
  }

  Future<BlogPost> show(int id) async {
    final response = await http.getJson('/api/blog-posts/$id');

    final dynamic data = response.data;

    if (data != null) {
      return BlogPost.fromJson(data);
    } else {
      throw const HttpException('Erro desconhecido');
    }
  }
}
