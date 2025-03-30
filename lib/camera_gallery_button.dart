import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class camera_gallery_button extends StatefulWidget {
  const camera_gallery_button({Key? key}) : super(key: key);

  @override
  State<camera_gallery_button> createState() => CamGalButState();
}

class CamGalButState extends State<camera_gallery_button> {
  File ? _selectedImage;

  Future<void> _getImageFromCamera() async {
    final returnedImage = await ImagePicker().pickImage(source: ImageSource.camera);

    if(returnedImage == null) return;
    setState(() {
      _selectedImage = File(returnedImage.path);
    });
  }

  Future<void> _getImageFromGallery() async {
    final returnedImage = await ImagePicker().pickImage(source: ImageSource.gallery);

    if(returnedImage == null) return;
    setState(() {
      _selectedImage = File(returnedImage.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                _getImageFromCamera();
              },
              child: Text('Get From Camera'),
            ),
            const SizedBox(height: 20,),
            _selectedImage != null ? Image.file(_selectedImage!) : const Text("Please get a camera image"),
            ElevatedButton(
              onPressed: () {
                _getImageFromGallery();
              },
              child: Text('Get From Gallery'),
            ),
          ],
        ),
      ),
    );
  }
}