
import 'dart:io';

import 'package:favorite_places/provider/user_places.dart';
import 'package:favorite_places/widgets/image_input.dart';
import 'package:favorite_places/widgets/locationn_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddPlaceScreen extends ConsumerStatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  ConsumerState<AddPlaceScreen> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends ConsumerState<AddPlaceScreen> {
  final _titleController = TextEditingController();
  File? _SelectedImage;

void _savePlace(){
  final enteredText = _titleController.text;

  if(enteredText.isEmpty || _SelectedImage== null){
    return ;
  }
ref.read(userPlaceProvider.notifier).addPlace(enteredText,_SelectedImage!);

Navigator.pop( context);
  
}
  @override
  void dispose() {
    // TODO: implement dispose
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add new Place'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'title'),
              controller: _titleController,
              style:  TextStyle(color: Theme.of(context).colorScheme.onBackground),
            ),
            // Image input
            SizedBox(
              height: 16,
            ),
            LocationInput(),
            SizedBox(
              height: 16,
            ),

            ImageInput(onPickImage: (image) => _SelectedImage=image,),
            SizedBox(
              height: 16,
            ),
            ElevatedButton.icon(
              onPressed: _savePlace,
              label: Text('Add place'),
              icon: Icon(Icons.add),
            )
          ],
        ),
      ),
    );
  }
}
