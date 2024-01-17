import 'package:bloc/bloc.dart';
import 'package:leve_sabor_admin_hub/enum/default_bloc_status_enum.dart';
import 'package:leve_sabor_admin_hub/model/blog_post.dart';
import 'package:leve_sabor_admin_hub/services/blog_posts_service.dart';
import 'package:leve_sabor_admin_hub/utils/http_exception.dart';
import 'package:meta/meta.dart';

part 'blog_posts_index_event.dart';

part 'blog_posts_index_state.dart';

class BlogPostsIndexBloc extends Bloc<BlogPostsIndexEvent, BlogPostsIndexState> {
  final BlogPostsService blogPostService;

  BlogPostsIndexBloc(this.blogPostService) : super(const BlogPostsIndexState()) {
    on<BlogPostsIndexEvent>((event, emit) async {
      try {
        if (event is RequestBlogPostsIndex) {
          emit(state.copyWith(status: DefaultBlocStatusEnum.loading));

          final List<BlogPost> blogPosts = await blogPostService.index();

          emit(state.copyWith(blogPosts: blogPosts, status: DefaultBlocStatusEnum.loaded));
        } else if (event is RequestDeleteBlogPost) {
          emit(state.copyWith(status: DefaultBlocStatusEnum.loading));

          await blogPostService.delete(event.id);

          final List<BlogPost> blogPosts = await blogPostService.index();

          emit(state.copyWith(blogPosts: blogPosts, status: DefaultBlocStatusEnum.loaded));
        }
      } on HttpException catch (httpException) {
        emit(state.copyWith(error: httpException.mensagem, status: DefaultBlocStatusEnum.error));
      } catch (e) {
        emit(state.copyWith(error: e.toString(), status: DefaultBlocStatusEnum.error));
      }
    });
  }
}
