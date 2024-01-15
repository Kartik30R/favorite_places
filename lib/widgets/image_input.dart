import 'dart:io';

import 'package:favorite_places/main.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({super.key, required this.onPickImage});

final void Function(File image) onPickImage;
  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _SelectedImage;

  void _takePicture() async {
    final imagepicker = ImagePicker();
    final pickedImage =
        await imagepicker.pickImage(source: ImageSource.camera, maxWidth: 600);

    if (pickedImage == null) {
      return;
    }
     setState(() {
           _SelectedImage == File(pickedImage.path);

     });

     widget.onPickImage(_SelectedImage!);
  }

  @override
  Widget build(BuildContext context) {
    Widget content =  TextButton.icon(
          onPressed: _takePicture,
          icon: Icon(Icons.camera),
          label: Text('Take picture'));

          if(_SelectedImage!= null){
            content = GestureDetector(onTap: _takePicture,child: Image.file(_SelectedImage!,height: double.infinity, fit: BoxFit.cover,width:  double.infinity,));
          }

    return Container(
      decoration: BoxDecoration(
          border:
              Border.all(width: 1, color: colorScheme.primary.withOpacity(.2))),
      height: 250,
      width: double.infinity,
      alignment: Alignment.center,
      child:content,
    );
  }
}
