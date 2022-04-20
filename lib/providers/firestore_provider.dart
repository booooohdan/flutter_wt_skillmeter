import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirestoreProvider with ChangeNotifier {
  // Provider Example
  //
  // late int _intValue;
  //
  // int get intValue => _intValue;
  //
  // void setIntValue(int intValueParam) {
  //   _intValue = intValueParam;
  //   notifyListeners();
  // }

  final _fireStoreInstance = FirebaseFirestore.instance;
}
