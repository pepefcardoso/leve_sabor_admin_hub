part of 'blog_posts_form_bloc.dart';

@immutable
class BlogPostsFormState {
  final List<BlogPostCategory> categories;
  final DefaultBlocStatusEnum status;
  final String? error;

  const BlogPostsFormState({
    this.categories = const [],
    this.status = DefaultBlocStatusEnum.initial,
    this.error,
  });

  BlogPostsFormState copyWith({
    List<BlogPostCategory>? categories,
    DefaultBlocStatusEnum? status,
    String? error,
  }) {
    return BlogPostsFormState(
      categories: categories ?? this.categories,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }
}
