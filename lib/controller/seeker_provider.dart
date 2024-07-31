import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:seeker/model/seeker_model.dart';
import 'package:seeker/service/firebase_service.dart';

class SeekerProvider extends ChangeNotifier {
  FirebaseService _firebaseService = FirebaseService();
  String uniquename = DateTime.now().microsecondsSinceEpoch.toString();
  String downloadurl = '';
  String _searchQuery = '';
  String pdfDownloadUrl = '';
  List<SeekerModel> _favorites = [];

  String get searchQuery => _searchQuery;
  List<SeekerModel> get favorites => _favorites;

  Stream<QuerySnapshot<SeekerModel>> getData() {
    if (_searchQuery.isEmpty) {
      return _firebaseService.seekerref.snapshots();
    } else {
      return _firebaseService.seekerref
          .where('name', isGreaterThanOrEqualTo: _searchQuery)
          .where('name', isLessThan: _searchQuery + 'z')
          .snapshots();
    }
  }

  Stream<List<SeekerModel>> get favoritesStream {
    return _firebaseService.favoritesRef.snapshots().map((snapshot) {
      return snapshot.docs
          .map(
              (doc) => SeekerModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  Stream<QuerySnapshot<SeekerModel>> getFilteredData(String category) {
    return _firebaseService.seekerref
        .where('category', isEqualTo: category)
        .snapshots();
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> loadFavorites() async {
    try {
      final snapshot = await _firebaseService.favoritesRef.get();
      _favorites = snapshot.docs.map((doc) => doc.data()).toList();
      notifyListeners();
    } catch (e) {
      print('Error loading favorites: $e');
    }
  }

  Future<void> addFavorite(SeekerModel seeker) async {
    try {
      await _firebaseService.favoritesRef.doc(seeker.id).set(seeker);
      _favorites.add(seeker);
      notifyListeners();
    } catch (e) {
      print('Error adding favorite: $e');
    }
  }

  Future<void> removeFavorite(SeekerModel seeker) async {
    try {
      print('Removing favorite with id: ${seeker.id}');
      await _firebaseService.favoritesRef.doc(seeker.id).delete();
      _favorites.removeWhere((item) => item.id == seeker.id);
      notifyListeners();
    } catch (e) {
      print('Error removing favorite: $e');
    }
  }

  bool isFavorite(SeekerModel seeker) {
    return _favorites.any((item) => item.id == seeker.id);
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

  Future<void> imageAdder(dynamic image) async {
    Reference folder = _firebaseService.storage.ref().child('images');
    Reference images = folder.child("$uniquename.jpg");

    try {
      if (image is File) {
        // Upload from File
        await images.putFile(image);
      } else if (image is Uint8List) {
        // Upload from Uint8List
        await images.putData(image);
      } else {
        throw Exception('Invalid image type');
      }

      downloadurl = await images.getDownloadURL();
      notifyListeners();
      print(downloadurl);
    } catch (e) {
      throw Exception(e);
    }
  }

  
  Future<void> imageAdderSeeker(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      await imageAdder(imageFile);
      notifyListeners();
    }
  }

  pdfAdder(pdfFile) async {
    Reference folder = _firebaseService.storage.ref().child('pdfs');
    Reference pdfs = folder.child("$uniquename.pdf");
    try {
      await pdfs.putFile(pdfFile);
      pdfDownloadUrl = await pdfs.getDownloadURL();
      notifyListeners();
      print(pdfDownloadUrl);
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
