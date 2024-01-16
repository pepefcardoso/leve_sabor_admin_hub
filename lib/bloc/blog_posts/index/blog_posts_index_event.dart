part of 'blog_posts_index_bloc.dart';

abstract class BlogPostsIndexEvent {
  const BlogPostsIndexEvent();
}

class RequestBlogPostsIndex extends BlogPostsIndexEvent {
  const RequestBlogPostsIndex();
}
