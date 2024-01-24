import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiwi/kiwi.dart';
import 'package:leve_sabor_admin_hub/bloc/blog_posts/form/blog_posts_form_bloc.dart';
import 'package:leve_sabor_admin_hub/components/checkbox/checkbox_group.dart';
import 'package:leve_sabor_admin_hub/components/checkbox/checkbox_group_controller.dart';
import 'package:leve_sabor_admin_hub/components/custom_text_formfield.dart';
import 'package:leve_sabor_admin_hub/components/image_picker.dart';
import 'package:leve_sabor_admin_hub/components/radio_box/radio_box_controller.dart';
import 'package:leve_sabor_admin_hub/components/radio_box/radio_box_group.dart';
import 'package:leve_sabor_admin_hub/enum/blog_post_status_enum.dart';
import 'package:leve_sabor_admin_hub/enum/default_bloc_status_enum.dart';
import 'package:leve_sabor_admin_hub/model/blog_post.dart';
import 'package:leve_sabor_admin_hub/services/blog_post_categories_service.dart';
import 'package:leve_sabor_admin_hub/services/blog_posts_service.dart';
import 'package:leve_sabor_admin_hub/utils/cores.dart';
import 'package:leve_sabor_admin_hub/utils/tipografia.dart';

class BlogPostsForm extends StatefulWidget {
  final int? id;
  final VoidCallback? onFinished;

  const BlogPostsForm({
    super.key,
    this.id,
    this.onFinished,
  });

  @override
  State<BlogPostsForm> createState() => _BlogPostsFormState();
}

class _BlogPostsFormState extends State<BlogPostsForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _contentController;
  late final CheckboxGroupController _categoriesController;
  late final RadioBoxController<String> _statusController;
  late final ImagePickerController _imageController;

  final KiwiContainer container = KiwiContainer();
  late final BlogPostsService _blogPostsService;
  late final BlogPostCategoriesService _blogPostCategoriesService;
  late final BlogPostsFormBloc _blogPostsFormBloc;

  void _onSubmit(BlogPost? post) {
    if (_formKey.currentState!.validate()) {
      final Map<String, dynamic> parameters = _getParameters(post);

      if (widget.id != null) {
        _blogPostsFormBloc.add(RequestUpdateBlogPostEvent(
          id: widget.id!,
          parameters: parameters,
        ));

        widget.onFinished?.call();
        return;
      }
      _blogPostsFormBloc.add(RequestSaveBlogPostEvent(
        parameters: parameters,
      ));

      widget.onFinished?.call();

      return;
    }
    return;
  }

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
    _statusController = RadioBoxController(BlogPostStatusEnum.published.value);
    _categoriesController = CheckboxGroupController();
    _imageController = ImagePickerController();

    _blogPostsFormBloc.stream.listen((state) {
      if (state.blogPost != null) {
        _titleController.text = state.blogPost!.title ?? '';
        _descriptionController.text = state.blogPost!.description ?? '';
        _contentController.text = state.blogPost!.content ?? '';
        _statusController.item = state.blogPost!.status?.value ?? BlogPostStatusEnum.published.value;
        _categoriesController.removeAndAddAll(state.blogPost!.categories?.map((category) => category.id!).toList() ?? []);
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
        backgroundColor: Cores.verde2,
        iconTheme: const IconThemeData(color: Cores.escuro),
        titleTextStyle: Tipografia.titulo3.copyWith(color: Cores.escuro),
      ),
      body: BlocProvider.value(
        value: _blogPostsFormBloc,
        child: BlocConsumer<BlogPostsFormBloc, BlogPostsFormState>(
          listener: (context, state) {
            if (state.status == DefaultBlocStatusEnum.error) {
              _showSnackBar(
                content: state.error ?? 'Erro desconhecido',
                bgColor: Colors.red,
              );
            }

            if (state.status == DefaultBlocStatusEnum.loaded) {
              Navigator.of(context).pop();
            }
          },
          builder: (context, state) {
            if (state.status == DefaultBlocStatusEnum.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 24.0),
                      CustomTextField(
                        controller: _titleController,
                        labelText: 'Título',
                        hintText: 'Insira aqui o título',
                        icon: Icons.title,
                        validator: (value) => _defaultTextFieldValidator(
                          value: value,
                          label: 'Título',
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      CustomTextField(
                        controller: _descriptionController,
                        labelText: 'Descrição',
                        hintText: 'Insira aqui a descrição',
                        icon: Icons.description,
                        validator: (value) => _defaultTextFieldValidator(
                          value: value,
                          label: 'Descrição',
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      CustomTextField(
                        controller: _contentController,
                        labelText: 'Conteúdo',
                        hintText: 'Insira aqui o conteúdo',
                        icon: Icons.content_copy_sharp,
                        validator: (value) => _defaultTextFieldValidator(
                          value: value,
                          label: 'Conteúdo',
                        ),
                      ),
                      const SizedBox(height: 24.0),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _TitleAndWidget(
                              title: 'Status',
                              widget: RadioBoxGroup<String>(
                                options: BlogPostStatusEnum.toMap,
                                controller: _statusController,
                                axis: Axis.vertical,
                              ),
                            ),
                          ),
                          Expanded(
                            child: _TitleAndWidget(
                              title: 'Categorias',
                              widget: CheckboxGroup(
                                options: {for (final category in state.categories) category.name!: category.id},
                                controller: _categoriesController,
                                axis: Axis.vertical,
                                mainAxisSpacing: 0,
                                crossAxisSpacing: 0,
                                spacing: 3,
                              ),
                            ),
                          ),
                          Expanded(
                            child: ImagePickerWidget(
                              controller: _imageController,
                              image: state.blogPost?.image,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => _onSubmit(state.blogPost),
                          child: const Text('Salvar'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  String? _defaultTextFieldValidator({
    required String? value,
    required String label,
  }) {
    if (value == null || value.isEmpty || value.length < 3) {
      return '$label inválido(a)';
    }

    return null;
  }

  Map<String, dynamic> _getParameters(BlogPost? post) {
    final BlogPostStatusEnum status = BlogPostStatusEnum.values.firstWhere((element) => element.value == _statusController.item);

    final Map<String, dynamic> imageData = {
      'id': _imageController.value != null ? null : post?.image?.id,
      'file': _imageController.value,
    };

    return {
      'title': _titleController.text,
      'description': _descriptionController.text,
      'content': _contentController.text,
      'status': status.value,
      'categories': _categoriesController.groupItems,
      'image': imageData,
    };
  }

  dynamic _showSnackBar({
    required String content,
    required Color bgColor,
  }) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();

    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          content,
          style: Tipografia.corpo2Bold,
        ),
        backgroundColor: bgColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
        ),
      ),
    );
  }
}

class _TitleAndWidget extends StatelessWidget {
  final String title;
  final Widget widget;

  const _TitleAndWidget({
    required this.title,
    required this.widget,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Tipografia.titulo2),
        const SizedBox(height: 4.0),
        widget,
      ],
    );
  }
}
