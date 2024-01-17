part of 'blog_posts_form_bloc.dart';

@immutable
class BlogPostsFormState {
  final List<BlogPostCategory> categories;
  final BlogPost? blogPost;
  final DefaultBlocStatusEnum status;
  final String? error;

  const BlogPostsFormState({
    this.categories = const [],
    this.blogPost,
    this.status = DefaultBlocStatusEnum.initial,
    this.error,
  });

  BlogPostsFormState copyWith({
    List<BlogPostCategory>? categories,
    BlogPost? blogPost,
    DefaultBlocStatusEnum? status,
    String? error,
  }) {
    return BlogPostsFormState(
      categories: categories ?? this.categories,
      blogPost: blogPost ?? this.blogPost,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }
}
