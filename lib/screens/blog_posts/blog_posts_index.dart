import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kiwi/kiwi.dart';
import 'package:leve_sabor_admin_hub/bloc/blog_posts/index/blog_posts_index_bloc.dart';
import 'package:leve_sabor_admin_hub/components/posts_list_item.dart';
import 'package:leve_sabor_admin_hub/enum/default_bloc_status_enum.dart';
import 'package:leve_sabor_admin_hub/model/blog_post.dart';
import 'package:leve_sabor_admin_hub/services/blog_posts_service.dart';
import 'package:leve_sabor_admin_hub/utils/custom_colors.dart';
import 'package:leve_sabor_admin_hub/utils/tipografia.dart';

class BlogPostsIndex extends StatefulWidget {
  const BlogPostsIndex({super.key});

  @override
  State<BlogPostsIndex> createState() => _BlogPostsIndexState();
}

class _BlogPostsIndexState extends State<BlogPostsIndex> {
  final KiwiContainer _kiwiContainer = KiwiContainer();
  late final BlogPostsService _blogPostsService;
  late final BlogPostsIndexBloc _blogPostsIndexBloc;

  @override
  void initState() {
    super.initState();

    _blogPostsService = _kiwiContainer.resolve<BlogPostsService>();

    _blogPostsIndexBloc = BlogPostsIndexBloc(_blogPostsService);

    _blogPostsIndexBloc.add(const RequestBlogPostsIndex());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blog Posts'),
        backgroundColor: Colors.green[900],
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: BlocProvider.value(
        value: _blogPostsIndexBloc,
        child: BlocConsumer<BlogPostsIndexBloc, BlogPostsIndexState>(
          listener: (context, state) {
            if (state.status == DefaultBlocStatusEnum.error) {
              _showSnackBar(
                content: state.error ?? 'Erro desconhecido',
                bgColor: Colors.red,
              );
            }
          },
          builder: (context, state) {
            if (state.status == DefaultBlocStatusEnum.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton(
                    onPressed: () => GoRouter.of(context).go(
                      '/home/blog-posts/new',
                      extra: _refreshData,
                    ),
                    child: const Text(
                      '+ Novo post',
                      style: Tipografia.titulo3,
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  if (state.blogPosts.isEmpty)
                    const Expanded(
                      child: Center(
                        child: Text(
                          'Nenhum post do blog foi encontrado!',
                          style: Tipografia.titulo1,
                        ),
                      ),
                    ),
                  if (state.blogPosts.isNotEmpty) ...[
                    Expanded(
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: state.blogPosts.length,
                        itemBuilder: (context, index) {
                          final BlogPost post = state.blogPosts[index];

                          return PostsItemList(
                            post: post,
                            color: CustomColors.randomColors[index % CustomColors.randomColors.length],
                            refreshData: _refreshData,
                            onConfirmDelete: () => _blogPostsIndexBloc.add(RequestDeleteBlogPost(post.id!)),
                          );
                        },
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _refreshData() {
    _blogPostsIndexBloc.add(const RequestBlogPostsIndex());
  }

  dynamic _showSnackBar({
    required String content,
    required Color bgColor,
  }) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();

    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          content,
          style: Tipografia.corpo2Bold,
        ),
        backgroundColor: bgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
    );
  }
}
