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
  final int? id;

  const BlogPostsForm({
    super.key,
    this.id,
  });

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
    _blogPostsService = container.resolve<BlogPostsService>();
    _blogPostCategoriesService = container.resolve<BlogPostCategoriesService>();
    _blogPostsFormBloc = BlogPostsFormBloc(_blogPostsService, _blogPostCategoriesService);
    _blogPostsFormBloc.add(const RequestGetBlogPostCategoriesEvent());

    if (widget.id != null) {
      _blogPostsFormBloc.add(RequestGetBlogPostEvent(id: widget.id!));
    }

    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _contentController = TextEditingController();
    _statusController = RadioController<String>(value: BlogPostStatusEnum.published.label);
    _categoriesController = CheckboxGroupController([]);
    _imageController = ImagePickerController();

    _blogPostsFormBloc.stream.listen((state) {
      if (state.blogPost != null) {
        _titleController.text = state.blogPost!.title ?? '';
        _descriptionController.text = state.blogPost!.description ?? '';
        _contentController.text = state.blogPost!.content ?? '';
        _statusController.value = state.blogPost!.status?.label ?? BlogPostStatusEnum.published.label;
        _categoriesController.value = state.blogPost!.categories?.map((category) => category.name!).toList() ?? [];
      }
    });
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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 32.0),
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Título',
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Descrição',
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: _contentController,
                      decoration: const InputDecoration(
                        labelText: 'Conteúdo',
                      ),
                      maxLines: 10,
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  for (final status in BlogPostStatusEnum.values) status.label,
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
                              const Text('Categorias'),
                              const SizedBox(height: 8.0),
                              CheckboxGroup(
                                items: state.categories.map((category) => category.name!).toList(),
                                controller: _categoriesController,
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: ImagePickerWidget(
                            controller: _imageController,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          final Map<String, dynamic>? parameters = _validateParameters();

                          if (parameters == null) {
                            return;
                          } else if (widget.id != null) {
                            _blogPostsFormBloc.add(RequestUpdateBlogPostEvent(
                              id: widget.id!,
                              parameters: parameters,
                            ));
                            return;
                          }
                          _blogPostsFormBloc.add(RequestSaveBlogPostEvent(
                            parameters: _getParameters(),
                          ));
                        },
                        child: const Text('Salvar'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Map<String, dynamic> _getParameters() {
    final List<int> categories = [];

    for (final category in _categoriesController.value) {
      final categoryFound = _blogPostsFormBloc.state.categories.firstWhere((element) => element.name == category);
      categories.add(categoryFound.id!);
    }

    final BlogPostStatusEnum status = BlogPostStatusEnum.values.firstWhere((element) => element.label == _statusController.value);

    return {
      'title': _titleController.text,
      'description': _descriptionController.text,
      'content': _contentController.text,
      'status': status.value,
      'categories': categories,
      'image': _imageController.value,
    };
  }

  Map<String, dynamic>? _validateParameters() {
    final List<String> errors = [];

    if (_titleController.text.isEmpty) {
      errors.add('O título é obrigatório');
    }

    if (_descriptionController.text.isEmpty) {
      errors.add('A descrição é obrigatória');
    }

    if (_contentController.text.isEmpty) {
      errors.add('O conteúdo é obrigatório');
    }

    if (_statusController.value == null || _statusController.value!.isEmpty) {
      errors.add('O status é obrigatório');
    }

    if (_categoriesController.value.isEmpty) {
      errors.add('A categoria é obrigatória');
    }

    if (_imageController.value == null) {
      errors.add('A imagem é obrigatória');
    }

    if (errors.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Verifique os campos obrigatórios'),
          backgroundColor: Colors.red,
        ),
      );

      return null;
    }

    return _getParameters();
  }
}
