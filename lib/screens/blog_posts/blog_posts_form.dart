import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiwi/kiwi.dart';
import 'package:leve_sabor_admin_hub/bloc/blog_posts/form/blog_posts_form_bloc.dart';
import 'package:leve_sabor_admin_hub/components/checkbox.dart';
import 'package:leve_sabor_admin_hub/components/image_picker.dart';
import 'package:leve_sabor_admin_hub/components/radio_box.dart';
import 'package:leve_sabor_admin_hub/enum/blog_post_status_enum.dart';
import 'package:leve_sabor_admin_hub/enum/default_bloc_status_enum.dart';
import 'package:leve_sabor_admin_hub/services/blog_post_categories_service.dart';
import 'package:leve_sabor_admin_hub/services/blog_posts_service.dart';

class BlogPostsForm extends StatefulWidget {
  const BlogPostsForm({super.key});

  @override
  State<BlogPostsForm> createState() => _BlogPostsFormState();
}

class _BlogPostsFormState extends State<BlogPostsForm> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _contentController;
  late final CheckboxGroupController _categoriesController;
  late final RadioController<String> _statusController;
  late final ImagePickerController _imageController;

  final KiwiContainer container = KiwiContainer();
  late final BlogPostsService _blogPostsService;
  late final BlogPostCategoriesService _blogPostCategoriesService;
  late final BlogPostsFormBloc _blogPostsFormBloc;

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _contentController = TextEditingController();
    _statusController =
        RadioController<String>(value: BlogPostStatusEnum.draft.toString());
    _categoriesController = CheckboxGroupController([]);
    _imageController = ImagePickerController();

    _blogPostsService = container.resolve<BlogPostsService>();
    _blogPostCategoriesService = container.resolve<BlogPostCategoriesService>();
    _blogPostsFormBloc =
        BlogPostsFormBloc(_blogPostsService, _blogPostCategoriesService);
    _blogPostsFormBloc.add(const RequestGetBlogPostCategoriesEvent());
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _contentController.dispose();
    _statusController.dispose();
    _categoriesController.dispose();
    _imageController.dispose();

    _blogPostsFormBloc.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo post'),
      ),
      body: BlocProvider.value(
        value: _blogPostsFormBloc,
        child: BlocConsumer<BlogPostsFormBloc, BlogPostsFormState>(
          listener: (context, state) {
            if (state.status == DefaultBlocStatusEnum.error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error ?? 'Erro desconhecido'),
                  backgroundColor: Colors.red,
                ),
              );
            }

            if (state.status == DefaultBlocStatusEnum.loaded) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Post criado com sucesso!'),
                  backgroundColor: Colors.green,
                ),
              );

              Navigator.of(context).pop();
            }
          },
          builder: (context, state) {
            if (state.status == DefaultBlocStatusEnum.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 32.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Título',
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Descrição',
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextFormField(
                      controller: _contentController,
                      decoration: const InputDecoration(
                        labelText: 'Conteúdo',
                      ),
                      maxLines: 10,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Status'),
                              const SizedBox(height: 8.0),
                              RadioGroup<String>(
                                controller: _statusController,
                                items: [
                                  BlogPostStatusEnum.draft.toString(),
                                  BlogPostStatusEnum.published.toString(),
                                  BlogPostStatusEnum.archived.toString(),
                                ],
                                onChanged: () {},
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Categories'),
                              const SizedBox(height: 8.0),
                              CheckboxGroup(
                                items: state.categories
                                    .map((category) => category.name!)
                                    .toList(),
                                controller: _categoriesController,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ImagePickerWidget(
                      controller: _imageController,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _blogPostsFormBloc.add(
                          RequestSaveBlogPostEvent(
                            parameters: _getParameters(),
                          ),
                        ),
                        child: const Text('Salvar'),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Map<String, dynamic> _getParameters() {
    return {
      'title': _titleController.text,
      'description': _descriptionController.text,
      'content': _contentController.text,
      'status': _statusController.value,
      'categories': _categoriesController.value,
      'image': _imageController.value,
    };
  }
}
