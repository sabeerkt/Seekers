// firebase_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:seeker/model/seeker_model.dart';


class FirebaseService { 
  
  String collectionref = 'Seeker';
  //instnce data aces cheyn
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  FirebaseStorage storage = FirebaseStorage.instance;
  late final CollectionReference<SeekerModel> seekerref;
    
  FirebaseService() {
    seekerref =
        firestore.collection(collectionref).withConverter<SeekerModel>(
              fromFirestore: (snapshot, options) =>
                  SeekerModel.fromJson(snapshot.data()!),
              toFirestore: (value, options) => value.toJson(),
            );
  }
}
