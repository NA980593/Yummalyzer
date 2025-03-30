import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CameraGalleryButton extends StatefulWidget {
  const CameraGalleryButton({super.key});

  @override
  State<CameraGalleryButton> createState() => CamGalButState();
}

class CamGalButState extends State<CameraGalleryButton> {
  File? _selectedImage;

  Future<void> _getImageFromCamera() async {
    final returnedImage = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );

    if (returnedImage == null) return;
    setState(() {
      _selectedImage = File(returnedImage.path);
    });
  }

  Future<void> _getImageFromGallery() async {
    final returnedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (returnedImage == null) return;
    setState(() {
      _selectedImage = File(returnedImage.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  _getImageFromCamera();
                },
                child: Text('Get From Camera'),
              ),
              const SizedBox(height: 20),
              _selectedImage != null
                  ? Image.file(_selectedImage!, height: 200, fit: BoxFit.cover)
                  : const Text("Please get a camera image"),
              ElevatedButton(
                onPressed: () {
                  _getImageFromGallery();
                },
                child: Text('Get From Gallery'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
