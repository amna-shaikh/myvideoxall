import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:permission_handler/permission_handler.dart';

import 'call_method.dart';
import 'call_model.dart';



class MycALL extends StatefulWidget {
  const MycALL({Key? key}) : super(key: key);

  @override
  State<MycALL> createState() => _MycALLState();
}

class _MycALLState extends State<MycALL> {
  int? _remoteUid;
  bool _localUserJoined = false;
  late RtcEngine _engine;
  bool muted = false;
  late StreamSubscription callStreamSubscription;
  final CallMethods callMethods = CallMethods();

  @override
  void initState() {
    super.initState();
    addPostFrameCallback();
    initAgora();
  }

  Future<void> initAgora() async {
    // retrieve permissions
    await [Permission.microphone, Permission.camera].request();

    //create the engine
    _engine = createAgoraRtcEngine();
    await _engine.initialize(const RtcEngineContext(
      appId: "a28be509a7404ebc9f42459393ba1cfa",
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));

    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint("local user ${connection.localUid} joined");
          setState(() {
            _localUserJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint("remote user $remoteUid joined");
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          debugPrint("remote user $remoteUid left channel");
          setState(() {
            _remoteUid = null;
          });
        },
        onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
          debugPrint(
              '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
        },
      ),
    );

    await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await _engine.enableVideo();
    await _engine.startPreview();

    await _engine.joinChannel(
      token: "007eJxTYMiXSf31if0Vk87hKU+Z/MSfa7dv5uryNtQ3u+San6kf1qzAkGhkkZRqamCZaG5iYJKalGyZZmJkYmppbGmclGiYnJaY22qd1hDIyHBzlSEjIwMEgvgsDCWpxSUMDACd0h05",
      channelId: "test",
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }

  @override
  void dispose() {
    _dispose();
    callStreamSubscription.cancel();
    super.dispose();
  }



  addPostFrameCallback() {
    SchedulerBinding.instance.addPostFrameCallback((_) {


      callStreamSubscription = callMethods
          .callStream(uid: "20")
          .listen((DocumentSnapshot ds) {

        if (!ds.exists) {
          // tell the user that the call was cancelled
          Navigator.of(context).pop();
          return;
        }
        // defining the logic
       /* switch (ds.data) {
          case null:
          // snapshot is null which means that call is hanged and documents are deleted
            Navigator.pop(context);
            break;

          default:
            break;
        }*/
      });
    });
  }

  Future<void> _dispose() async {
    await _engine.leaveChannel();
    await _engine.release();
  }

  // Create UI with local view and remote view

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    _engine.muteLocalAudioStream(muted);
  }

  void _onSwitchCamera() {
    _engine.switchCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agora Video Call'),
      ),
      body: Stack(
        children: [
          Center(
            child: _remoteVideo(),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 100,
              height: 150,
              child: Center(
                child: _localUserJoined
                    ? AgoraVideoView(
                  controller: VideoViewController(
                    rtcEngine: _engine,
                    canvas: const VideoCanvas(uid: 0),
                  ),
                )
                    : const CircularProgressIndicator(),
              ),
            ),
          ),

    Container(
    alignment: Alignment.bottomCenter,
    padding: const EdgeInsets.symmetric(vertical: 48),
    child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
    RawMaterialButton(
    onPressed: _onToggleMute,
    child: Icon(
    muted ? Icons.mic : Icons.mic_off,
    color: muted ? Colors.white : Colors.blueAccent,
    size: 20.0,
    ),
    shape: CircleBorder(),
    elevation: 2.0,
    fillColor: muted ? Colors.blueAccent : Colors.white,
    padding: const EdgeInsets.all(12.0),
    ),
    RawMaterialButton(
    onPressed: () => callMethods.endCall(
    call: Call(
      callerId: "20",
      callerName: "amna",
      callerPic: "",
      receiverId: "18",
      receiverName: "ALI",
      receiverPic: "",
      channelId: "test", hasDialled: false,
    ),
      context: context
    ),
    child: Icon(
    Icons.call_end,
    color: Colors.white,
    size: 35.0,
    ),
    shape: CircleBorder(),
    elevation: 2.0,
    fillColor: Colors.redAccent,
    padding: const EdgeInsets.all(15.0),
    ),
    RawMaterialButton(
    onPressed: _onSwitchCamera,
    child: Icon(
    Icons.switch_camera,
    color: Colors.blueAccent,
    size: 20.0,
    ),
    shape: CircleBorder(),
    elevation: 2.0,
    fillColor: Colors.white,
    padding: const EdgeInsets.all(12.0),
    )
    ],
    ),
    )
        ],
      ),
    );
  }

  // Display remote user's video
  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine,
          canvas: VideoCanvas(uid: _remoteUid),
          connection: const RtcConnection(channelId: "test"),
        ),
      );
    } else {
      return const Text(
        'Please wait for remote user to join',
        textAlign: TextAlign.center,
      );
    }
  }
}