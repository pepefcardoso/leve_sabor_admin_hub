part of 'blog_posts_form_bloc.dart';

abstract class BlogPostsFormEvent {
  const BlogPostsFormEvent();
}

class RequestSaveBlogPostEvent extends BlogPostsFormEvent {
  final Map<String, dynamic> parameters;

  const RequestSaveBlogPostEvent({required this.parameters});
}

class RequestGetBlogPostCategoriesEvent extends BlogPostsFormEvent {
  const RequestGetBlogPostCategoriesEvent();
}
