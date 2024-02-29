import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class FirebaseService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  Future<String> getImageUrl(String imageName) async {
    String uppercaseImageName = imageName.isNotEmpty
        ? '${imageName[0].toUpperCase()}${imageName.substring(1)}'
        : '';
    String imageUrl = await storage.ref('legends/$uppercaseImageName').getDownloadURL();
    return imageUrl;
  }



  Future<String> uploadImage(File imageFile, String targetPath) async {
    try {
      await storage.ref(targetPath).putFile(imageFile);
      return await storage.ref(targetPath).getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }


}
