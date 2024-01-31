import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:leve_sabor_admin_hub/model/blog_post_image.dart';
import 'package:leve_sabor_admin_hub/utils/tipografia.dart';

class ImagePickerWidget extends StatefulWidget {
  final BlogPostImage? image;
  final ImagePickerController controller;
  final VoidCallback? onError;

  const ImagePickerWidget({
    super.key,
    this.image,
    required this.controller,
    this.onError,
  });

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  @override
  void initState() {
    super.initState();

    if (mounted) widget.controller.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16.0),
      onTap: _pickImage,
      hoverColor: Colors.green[100],
      splashColor: Colors.green[400],
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
        ),
        height: 200.0,
        width: 200.0,
        child: widget.controller.value != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: Image.file(
                  File(widget.controller.value!.path),
                  fit: BoxFit.cover,
                ),
              )
            : widget.image != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: Image.network(
                      widget.image!.url!,
                      fit: BoxFit.cover,
                    ),
                  )
                : Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add_a_photo, size: 64.0, color: Colors.green[800]),
                        const Text(
                          'Selecione uma imagem',
                          style: Tipografia.titulo3,
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }

  void _pickImage() async {
    final XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      final File file = File(pickedFile.path);

      final image = await decodeImageFromList(file.readAsBytesSync());

      if (image.width >= 800 || image.height >= 800) {
        widget.controller.setImage(File(pickedFile.path));
      }

      if (widget.onError != null) widget.onError!();

      return;
    }
  }
}

class ImagePickerController extends ValueNotifier<File?> {
  ImagePickerController() : super(null);

  void setImage(File image) {
    value = image;
    notifyListeners();
  }
}
