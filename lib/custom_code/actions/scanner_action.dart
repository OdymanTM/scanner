// Automatic FlutterFlow imports
import '/backend/schema/enums/enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:convert';

import 'dart:io';

import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

Future<String> scannerAction(BuildContext context) async {
  List<String> _pictures = [];
  List<String> pictures = [];
  String resultMessage = 'Failed to save images';

  try {
    pictures = await CunningDocumentScanner.getPictures(
            isGalleryImportAllowed: true) ??
        [];
    _pictures = pictures;
  } catch (exception) {
    // Handle exception here
    return exception.toString();
  }

  final time = DateTime.now()
      .toIso8601String()
      .replaceAll('.', '-')
      .replaceAll(':', '-');
  int count = 1;
  bool allSuccess = true;

  for (var picture in pictures) {
    final name = 'cropimage_${time}_$count';
    final saveResult = await ImageGallerySaver.saveFile(picture,
        name: name, isReturnPathOfIOS: true);

    if (!saveResult['isSuccess']) {
      allSuccess = false;
      break;
    }

    count++;
  }

  if (allSuccess) {
    resultMessage = 'All photos saved successfully in the gallery!';
  }

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: Duration(seconds: 7),
      content: Text(resultMessage),
    ),
  );

  return 'end';
}
