import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpApi {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  static Future<bool> addUser({
    required XFile profile,
    required String name,
    required String email,
    required String phone,
  }) async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;

      final uid = auth.currentUser!.uid;

      Reference ref = FirebaseStorage.instance.ref('gym_logo/$uid.jpg');
      await ref.putFile(File(profile.path));
      String imgUrl = await ref.getDownloadURL();

      await _firestore.collection('Users').doc(uid).set({
        'userId': uid,
        'name': name,
        'email': email,
        'phone': phone,
        'imgUrl': imgUrl,
      });
      print("User added to Firebase");

      // Return true to indicate success
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error adding user: $e');
      }

      // Return false to indicate failure
      return false;
    }
  }

  static Future<String> uploadGymLogo(String profileImg, String name) async {
    String uniqueFileName = "$name-${DateTime.now()}";
    Reference ref = _storage.ref();
    Reference refDirProfileImg = ref.child('profile');
    Reference refImage = refDirProfileImg.child(uniqueFileName);

    try {
      await refImage.putFile(File(profileImg));
      String downloadURL = await refImage.getDownloadURL();
      print('imageUrl$downloadURL');
      return downloadURL;
    } catch (e) {
      print('Error uploading profile image: $e');
      return 'https://firebasestorage.googleapis.com/v0/b/gymify-7dc64.appspot.com/o/profileImages%2Fman.png?alt=media&token=f4174a50-d9a2-4679-8545-12fb1bd454ec'; // Handle the error appropriately in your application
    }
  }
}
