import 'package:flutter/foundation.dart';
import '../services/firebase_service.dart';

class ImageRepository {
  final FirebaseService _firebaseService;

  ImageRepository( this._firebaseService);

  Future<String> fetchImageUrl(String imageName) async {
    try {
      return await _firebaseService.getImageUrl(imageName);
    } catch (e) {
      // Handle or rethrow the exception
      if (kDebugMode) {
        print(e);
      }
      rethrow;
    }
  }

// Add methods for caching and retrieving images locally
}
