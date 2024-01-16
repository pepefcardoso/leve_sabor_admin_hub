part of 'blog_posts_index_bloc.dart';

@immutable
class BlogPostsIndexState {
  final List<BlogPost> blogPosts;
  final DefaultBlocStatusEnum status;
  final String? error;

  const BlogPostsIndexState({
    this.blogPosts = const [],
    this.status = DefaultBlocStatusEnum.initial,
    this.error,
  });

  BlogPostsIndexState copyWith({
    List<BlogPost>? blogPosts,
    DefaultBlocStatusEnum? status,
    String? error,
  }) {
    return BlogPostsIndexState(
      blogPosts: blogPosts ?? this.blogPosts,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }
}
