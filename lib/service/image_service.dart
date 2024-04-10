import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

class ImageService {

  static String convertImageToBase64String(File imageFile) {
    List<int> imageBytes = imageFile.readAsBytesSync();
    return base64Encode(imageBytes);
  }

  static Uint8List imageFromBase64String(String base64String) {
    return base64Decode(base64String);
  }
}