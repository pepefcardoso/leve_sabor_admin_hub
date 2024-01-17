import 'package:bloc/bloc.dart';
import 'package:leve_sabor_admin_hub/enum/default_bloc_status_enum.dart';
import 'package:leve_sabor_admin_hub/model/blog_post.dart';
import 'package:leve_sabor_admin_hub/model/blog_post_category.dart';
import 'package:leve_sabor_admin_hub/services/blog_post_categories_service.dart';
import 'package:leve_sabor_admin_hub/services/blog_posts_service.dart';
import 'package:leve_sabor_admin_hub/utils/http_exception.dart';
import 'package:meta/meta.dart';

part 'blog_posts_form_event.dart';

part 'blog_posts_form_state.dart';

class BlogPostsFormBloc extends Bloc<BlogPostsFormEvent, BlogPostsFormState> {
  final BlogPostsService blogPostService;
  final BlogPostCategoriesService categoriesService;

  BlogPostsFormBloc(this.blogPostService, this.categoriesService) : super(const BlogPostsFormState()) {
    on<BlogPostsFormEvent>((event, emit) async {
      try {
        if (event is RequestGetBlogPostCategoriesEvent) {
          emit(state.copyWith(status: DefaultBlocStatusEnum.loading));

          final List<BlogPostCategory> categories = await categoriesService.index();

          emit(state.copyWith(
            categories: categories,
            status: DefaultBlocStatusEnum.initial,
          ));
        } else if (event is RequestSaveBlogPostEvent) {
          emit(state.copyWith(status: DefaultBlocStatusEnum.loading));

          await blogPostService.register(event.parameters);

          emit(state.copyWith(
            status: DefaultBlocStatusEnum.loaded,
          ));
        } else if (event is RequestGetBlogPostEvent) {
          emit(state.copyWith(status: DefaultBlocStatusEnum.loading));

          final BlogPost blogPost = await blogPostService.show(event.id);

          emit(state.copyWith(blogPost: blogPost, status: DefaultBlocStatusEnum.initial));
        } else if (event is RequestUpdateBlogPostEvent) {
          emit(state.copyWith(status: DefaultBlocStatusEnum.loading));

          await blogPostService.update(event.id, event.parameters);

          emit(state.copyWith(
            status: DefaultBlocStatusEnum.loaded,
          ));
        }
      } on HttpException catch (httpException) {
        emit(state.copyWith(error: httpException.mensagem, status: DefaultBlocStatusEnum.error));
      } catch (e) {
        emit(state.copyWith(
          status: DefaultBlocStatusEnum.error,
          error: e.toString(),
        ));
      }
    });
  }
}
