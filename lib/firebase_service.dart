import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  static final COLLECTION_REF = 'user';

  final firestore = FirebaseFirestore.instance;
  late final CollectionReference userRef;

  FirebaseService() {
    userRef = firestore.collection(COLLECTION_REF);
  }

  void tambah(UserData userData) {
    DocumentReference documentReference = userRef.doc(userData.email);
    documentReference.set(userData.toJson());
  }
}

class UserData {
  String email;
  String password;

  UserData(this.email, this.password);

  Map<String, dynamic> toJson() {
    return {'email': this.email, 'password': this.password};
  }
}
