import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

import 'callVideo.dart';
import 'call_method.dart';
import 'call_model.dart';
import 'myvideo.dart';


class PickupScreen extends StatelessWidget {
  final Call call;
  final CallMethods callMethods = CallMethods();

  PickupScreen({
    required this.call,
  });
  void initState() {
    print("initState Called");
    FlutterRingtonePlayer.play(
      android: AndroidSounds.ringtone,
      ios: IosSounds.glass,
      looping: true, // Android only - API >= 28, // Android only - API >= 28
      asAlarm: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Incoming...",
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            SizedBox(height: 50),
           /* CircleAvatar(
              call.callerPic,
              isRound: true,
              radius: 180,
            ),*/
            SizedBox(height: 15),
            Text(
              call.callerName.toString(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 75),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.call_end),
                  color: Colors.redAccent,
                  onPressed: () async {
                    FlutterRingtonePlayer.stop();
                    await callMethods.endCall(call: call,context: context);
                  },
                ),
                SizedBox(width: 25),
                IconButton(
                  icon: Icon(Icons.call),
                  color: Colors.green,
                  onPressed: () async {
                    FlutterRingtonePlayer.stop();
                  //await Permissions.cameraAndMicrophonePermissionsGranted() ?
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MycALL(),
                    ),
                  );}
                    //  : {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}