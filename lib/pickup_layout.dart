import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myvideoxall/pickup_screen.dart';

import 'call_method.dart';
import 'call_model.dart';


class PickupLayout extends StatelessWidget {
  final Widget scaffold;
  final CallMethods callMethods = CallMethods();

  PickupLayout({
    required this.scaffold,
  });

  @override
  Widget build(BuildContext context) {

   // return (userProvider != null && userProvider.getUser != null) ?
     return StreamBuilder<DocumentSnapshot>(
      stream: callMethods.callStream(uid: "18"),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data?.data != null) {
    if (snapshot.data!.data != null) {
      Object? callData = snapshot.data!.data(); // Ca
    if (callData != null && callData is Map) {
      Call call = Call.fromMap(callData as Map);
      if (!call.hasDialled) {
        return PickupScreen(call: call);
      }}
    }
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}'); // Handle error
        } else if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator()); // Show loading indicator
        }
        return scaffold;
      },
    );
        /*: Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );*/
  }
}