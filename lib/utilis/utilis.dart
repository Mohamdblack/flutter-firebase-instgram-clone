import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Utilis {
  pickImage(ImageSource source) async {
    final ImagePicker imagePicker = ImagePicker();

    XFile? file = await imagePicker.pickImage(source: source);

    if (file != null) {
      return await file.readAsBytes();
    }
    log("No image selected");
  }

  showSnackBar(String content, Color colorr, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: colorr,
        content: Text(
          content,
        ),
      ),
    );
  }
}
