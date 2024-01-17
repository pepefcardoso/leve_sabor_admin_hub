import 'dart:io';

import 'package:dio/dio.dart';
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
    final MultipartFile image = MultipartFile.fromBytes(
      (parameters['image']).readAsBytesSync(),
      filename: (parameters['image'] as File).path.split('/').last,
    );

    parameters['image'] = image;

    final response = await http.postJson('/api/blog-posts', dados: FormData.fromMap(parameters, ListFormat.multiCompatible));

    final dynamic data = response.data;

    if (data != null) {
      return BlogPost.fromJson(data);
    } else {
      throw const HttpException('Erro desconhecido');
    }
  }

  Future<BlogPost> update(int id, Map<String, dynamic> parameters) async {
    final MultipartFile image = MultipartFile.fromBytes(
      (parameters['image']).readAsBytesSync(),
      filename: (parameters['image'] as File).path.split('/').last,
    );

    parameters['image'] = image;

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
    final response = await http.deleteJson('/api/blog-posts/$id');

    if (response.statusCode != HttpStatus.noContent) {
      throw const HttpException('Erro desconhecido');
    }
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
