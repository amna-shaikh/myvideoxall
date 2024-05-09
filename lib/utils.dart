import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

import 'callVideo.dart';
import 'call_method.dart';
import 'call_model.dart';
import 'myvideo.dart';


class CallUtils {
  static final CallMethods callMethods = CallMethods();

  static dial({context}) async {
    Call call = Call(
      callerId: "20",
      callerName: "amna",
      callerPic: "",
      receiverId: "18",
      receiverName: "ALI",
      receiverPic: "",
      channelId: "test", hasDialled: true,
    );

    bool callMade = await callMethods.makeCall(call: call);

    call.hasDialled = true;

    if (callMade) {

      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MycALL(),
          ));
    }
  }
}