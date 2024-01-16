import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kiwi/kiwi.dart';
import 'package:leve_sabor_admin_hub/bloc/blog_posts/index/blog_posts_index_bloc.dart';
import 'package:leve_sabor_admin_hub/enum/default_bloc_status_enum.dart';
import 'package:leve_sabor_admin_hub/services/blog_posts_service.dart';

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
      body: BlocProvider.value(
        value: _blogPostsIndexBloc,
        child: BlocConsumer<BlogPostsIndexBloc, BlogPostsIndexState>(
          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (context, state) {
            if (state.status == DefaultBlocStatusEnum.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return Column(
              children: [
                TextButton(
                  onPressed: () => GoRouter.of(context).go('/blog_posts/new'),
                  child: const Text('Novo post'),
                ),
                const SizedBox(height: 32.0),
                if (state.blogPosts.isEmpty)
                  const Text('Nenhum post do blog foi encontrado!'),
                if (state.blogPosts.isNotEmpty) ...[
                  for (var blogPost in state.blogPosts)
                    ListTile(
                        title: Text(blogPost.title ?? 'Não informado'),
                        subtitle: Text(blogPost.description ?? 'Não informado'),
                        trailing: Image.network(
                          blogPost.imageUrl ?? '',
                          width: 100.0,
                          height: 100.0,
                        )),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
