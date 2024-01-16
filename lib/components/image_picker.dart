import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatefulWidget {
  final ImagePickerController controller;

  const ImagePickerWidget({super.key, required this.controller});

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  @override
  void initState() {
    super.initState();

    widget.controller.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        widget.controller.value != null
            ? Image.file(
                File(widget.controller.value!.path),
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              )
            : const Placeholder(
                fallbackHeight: 100,
                fallbackWidth: 100,
              ),
        ElevatedButton(
          onPressed: () async {
            final pickedFile =
                await ImagePicker().pickImage(source: ImageSource.gallery);

            if (pickedFile != null) {
              widget.controller.setImage(File(pickedFile.path));
            }
          },
          child: Text('Pick Image'),
        ),
      ],
    );
  }
}

class ImagePickerController extends ValueNotifier<File?> {
  ImagePickerController() : super(null);

  void setImage(File image) {
    value = image;
    notifyListeners();
  }
}
