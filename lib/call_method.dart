import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'call_model.dart';


class CallMethods {
  final CollectionReference callCollection =
  FirebaseFirestore.instance.collection(
    'call'
  );

  Stream<DocumentSnapshot> callStream({required String uid}) =>
      callCollection.doc(uid).snapshots();

  Future<bool> makeCall({required Call call}) async {
    try {
      call.hasDialled = true;
      Map<String, dynamic> hasDialledMap = call.toMap(call);

      call.hasDialled = false;
      Map<String, dynamic> hasNotDialledMap = call.toMap(call);

      await callCollection.doc(call.callerId).set(hasDialledMap);
      await callCollection.doc(call.receiverId).set(hasNotDialledMap);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> endCall({required Call call, context}) async {
    try {
      await callCollection.doc(call.callerId).delete();
      await callCollection.doc(call.receiverId).delete();
      //Navigator.pop(context);
      return true;

    } catch (e) {
      print(e);
      return false;
    }
  }
}