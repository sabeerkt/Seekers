import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:seeker/model/seeker_model.dart';

class FirebaseService {
  String collectionref = 'Seeker';
  String favoritesCollectionRef = 'Favorites';
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;
  late final CollectionReference<SeekerModel> seekerref;
  late final CollectionReference<SeekerModel> favoritesRef;

  FirebaseService() {
    seekerref = firestore.collection(collectionref).withConverter<SeekerModel>(
          fromFirestore: (snapshot, options) =>
              SeekerModel.fromJson(snapshot.data()!),
          toFirestore: (value, options) => value.toJson(),
        );
    favoritesRef = firestore.collection(favoritesCollectionRef).withConverter<SeekerModel>(
          fromFirestore: (snapshot, options) =>
              SeekerModel.fromJson(snapshot.data()!),
          toFirestore: (value, options) => value.toJson(),
        );
  }
}