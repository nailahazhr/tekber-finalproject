import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ns_apps/data_to_cloud/clsNutrisi.dart';

const String collectionName = "Nutrisi";

class Srvcnutrisi {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late final CollectionReference _nutrisiRef;

  //Constructor
  Srvcnutrisi() {
    _nutrisiRef = _firestore
        .collection(collectionName)
        .withConverter<ClsNutrisi>(
            fromFirestore: (snapshot, _) =>
                ClsNutrisi.fromJson(snapshot.data()!),
            toFirestore: (nutrisi, _) => nutrisi.toJson());
  }

  // Service

  // Add data
  Future<void> addMakan(ClsNutrisi makan) async {
    await _nutrisiRef.add(makan);
  }
}
