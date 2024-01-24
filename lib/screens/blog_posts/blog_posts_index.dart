import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kiwi/kiwi.dart';
import 'package:leve_sabor_admin_hub/bloc/blog_posts/index/blog_posts_index_bloc.dart';
import 'package:leve_sabor_admin_hub/enum/default_bloc_status_enum.dart';
import 'package:leve_sabor_admin_hub/services/blog_posts_service.dart';
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
                    child: const Text('Novo post'),
                  ),
                  const SizedBox(height: 32.0),
                  if (state.blogPosts.isEmpty) const Text('Nenhum post do blog foi encontrado!'),
                  if (state.blogPosts.isNotEmpty) ...[
                    Expanded(
                      child: ListView.separated(
                        itemCount: state.blogPosts.length,
                        separatorBuilder: (context, index) => const Divider(),
                        itemBuilder: (context, index) {
                          final blogPost = state.blogPosts[index];

                          return ListTile(
                            title: Text(blogPost.title ?? ''),
                            subtitle: Text(blogPost.description ?? ''),
                            leading: blogPost.image?.url != null
                                ? Image.network(
                                    blogPost.image!.url!,
                                    width: 100.0,
                                    height: 100.0,
                                    fit: BoxFit.cover,
                                  )
                                : null,
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () => GoRouter.of(context).go(
                                    '/home/blog-posts/edit/${blogPost.id}',
                                    extra: _refreshData,
                                  ),
                                  icon: const Icon(Icons.edit),
                                ),
                                const SizedBox(width: 8.0),
                                IconButton(
                                  onPressed: () => _showDeleteDialog(context, () {
                                    _blogPostsIndexBloc.add(RequestDeleteBlogPost(blogPost.id!));
                                    _refreshData();
                                    Navigator.of(context).pop();
                                  }),
                                  icon: const Icon(Icons.delete),
                                ),
                              ],
                            ),
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

Future<void> _showDeleteDialog(BuildContext context, VoidCallback onConfirm) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Atenção'),
        content: const Text('Deseja deletar este post?'),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('Confirmar'),
            onPressed: () => onConfirm(),
          ),
        ],
      );
    },
  );
}
