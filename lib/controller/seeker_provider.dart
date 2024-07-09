import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:seeker/model/seeker_model.dart';
import 'package:seeker/service/firebase_service.dart';

class Seeker extends ChangeNotifier {
  FirebaseService _firebaseService = FirebaseService();
  String uniquename = DateTime.now().microsecondsSinceEpoch.toString();
  String downloadurl = '';

  Stream<QuerySnapshot<SeekerModel>> getData() {
    return _firebaseService.seekerref.snapshots();
  }

  addSeeker(SeekerModel seeker) async {
    await _firebaseService.seekerref.add(seeker);
    notifyListeners();
  }


  deleteSeeker(id) async {
    await _firebaseService.seekerref.doc(id).delete();
    notifyListeners();
  }

  updateSeeker(id, SeekerModel seeker) async {
    await _firebaseService.seekerref.doc(id).update(seeker.toJson());
    notifyListeners();
  }

  imageAdder(image) async {
    Reference folder = _firebaseService.storage.ref().child('images');
    Reference images = folder.child("$uniquename.jpg");
    try {
      await images.putFile(image);
      downloadurl = await images.getDownloadURL();
      notifyListeners();
      print(downloadurl);
    } catch (e) {
      throw Exception(e);
    }
  }

   updateImage(imageurl, File? newimage) async {
    try {
      if (newimage != null && newimage.existsSync()) {
        Reference storedimage = FirebaseStorage.instance.refFromURL(imageurl);
        await storedimage.putFile(newimage);
        downloadurl = await storedimage.getDownloadURL();
        print("Image uploaded successfully. Download URL: $downloadurl");
      } else {
        // If no new image or new image is null or doesn't exist, keep the existing URL
        downloadurl = imageurl;
        print("No new image provided. Using existing URL: $downloadurl");
      }
    } catch (e) {
      print("Error updating image: $e");
    }
  }

  deleteImage(imageurl) async {
    Reference storedimage = FirebaseStorage.instance.refFromURL(imageurl);
    await storedimage.delete();
  }





  
}