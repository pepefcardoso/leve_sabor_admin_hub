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

class RequestGetBlogPostEvent extends BlogPostsFormEvent {
  final int id;

  const RequestGetBlogPostEvent({required this.id});
}

class RequestUpdateBlogPostEvent extends BlogPostsFormEvent {
  final int id;
  final Map<String, dynamic> parameters;

  const RequestUpdateBlogPostEvent({required this.id, required this.parameters});
}
