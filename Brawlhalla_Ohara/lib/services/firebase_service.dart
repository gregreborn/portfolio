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


  Future<void> savePlayerData(Map<String, dynamic> playerData) async {
    await firestore.collection('players').doc(playerData['brawlhalla_id'].toString()).set(playerData);
  }

  Future<Map<String, dynamic>?> getPlayerData(String brawlhallaId) async {
    DocumentSnapshot snapshot = await firestore.collection('players').doc(brawlhallaId).get();
    return snapshot.exists ? snapshot.data() as Map<String, dynamic> : null;
  }

  Future<void> saveClanData(Map<String, dynamic> clanData) async {
    await firestore.collection('clans').doc(clanData['clan_id'].toString()).set(clanData);
  }

  Future<Map<String, dynamic>?> getClanData(String clanId) async {
    DocumentSnapshot snapshot = await firestore.collection('clans').doc(clanId).get();
    return snapshot.exists ? snapshot.data() as Map<String, dynamic> : null;
  }

  Future<String> uploadImage(File imageFile, String targetPath) async {
    try {
      await storage.ref(targetPath).putFile(imageFile);
      return await storage.ref(targetPath).getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  Stream<DocumentSnapshot> listenToPlayerData(String brawlhallaId) {
    return firestore.collection('players').doc(brawlhallaId).snapshots();
  }

  Stream<DocumentSnapshot> listenToClanData(String clanId) {
    return firestore.collection('clans').doc(clanId).snapshots();
  }

}
