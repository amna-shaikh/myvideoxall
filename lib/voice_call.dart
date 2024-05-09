import 'dart:async';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';

class VoiceCall extends StatefulWidget {
  const VoiceCall({Key? key}) : super(key: key);

  @override
  _VoiceCallState createState() => _VoiceCallState();
}

class _VoiceCallState extends State<VoiceCall> {
   String  appId=  "a28be509a7404ebc9f42459393ba1cfa";
  String token=  "007eJxTYMiXSf31if0Vk87hKU+Z/MSfa7dv5uryNtQ3u+San6kf1qzAkGhkkZRqamCZaG5iYJKalGyZZmJkYmppbGmclGiYnJaY22qd1hDIyHBzlSEjIwMEgvgsDCWpxSUMDACd0h05";
  String channelId=  "test";
 // uid: 0,

   bool muted = false;
  String channelName = "test";
 // String token = "<--Insert authentication token here-->";
  int uid = 0; // uid of the local user

  int? _remoteUid; // uid of the remote user
  bool _isJoined = false; // Indicates if the local user has joined the channel
  late RtcEngine agoraEngine; // Agora engine instance

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey
  = GlobalKey<ScaffoldMessengerState>(); // Global key to access the scaffold
  @override
  void initState() {
    super.initState();
    // Set up an instance of Agora engine
    setupVoiceSDKEngine();
  }
  Future<void> setupVoiceSDKEngine() async {
    // retrieve or request microphone permission
    await [Permission.microphone].request();

    //create an instance of the Agora engine
    agoraEngine = createAgoraRtcEngine();
    await agoraEngine.initialize( RtcEngineContext(
        appId: "a28be509a7404ebc9f42459393ba1cfa",
    ));

    // Register the event handler
    agoraEngine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          showMessage("Local user uid:${connection.localUid} joined the channel");
          setState(() {
            _isJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          showMessage("Remote user uid:$remoteUid joined the channel");
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          showMessage("Remote user uid:$remoteUid left the channel");
          setState(() {
            _remoteUid = null;
          });
        },
      ),
    );

  //void  join() async {

    // Set channel options including the client role and channel profile
    ChannelMediaOptions options = const ChannelMediaOptions(
      clientRoleType: ClientRoleType.clientRoleBroadcaster,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    );

    await agoraEngine.joinChannel(
      token: token,
      channelId: channelName,
      options: options,
      uid: uid,
    );
  }
  //}
  void leave() {
    setState(() {
      _isJoined = false;
      _remoteUid = null;
    });
    agoraEngine.leaveChannel();
    Navigator.pop(context);
  }
// Clean up the resources when you leave
  @override
  void dispose() async {
    await agoraEngine.leaveChannel();
    super.dispose();
  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    agoraEngine.muteLocalAudioStream(muted);
  }


  // Build UI
  @override
  Widget build(BuildContext context) {

   return Scaffold(
   appBar: AppBar(
   title: const Text('Agora Voice Call'),
   ),
   body: Stack(
   children: [
   Center(
   child: _remoteVideo(),
   ),

     Align(

    alignment: Alignment.topLeft,
      child: _localVideo(),

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
    onPressed: () => leave(),
     //
     // callMethods.endCall(
   // call: Call(
   // callerId: "20",
   // callerName: "amna",
   // callerPic: "",
   // receiverId: "18",
   // receiverName: "ALI",
   // receiverPic: "",
   // channelId: "test", hasDialled: false,
   // ),
   // context: context
   // ),
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

   ],
   ),
   )
   ],
   ),
   );



  /* return   Scaffold(
          appBar: AppBar(
            title: const Text('Get started with Voice Calling'),
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            children: [
              // Status text
              Container(
                  height: 40,
                  child:Center(
                      child:_status()
                  )
              ),
              // Button Row
              Row(
                children: <Widget>[
                  Expanded(
                    child: ElevatedButton(
                      child: const Text("Join"),
                      onPressed: () => {join()},
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      child: const Text("Leave"),
                      onPressed: () => {leave()},
                    ),
                  ),
                ],
              ),
            ],
          ),
    );*/
  }

  Widget _status(){
    String statusText;

    if (!_isJoined)
      statusText = 'Join a channel';
    else if (_remoteUid == null)
      statusText = 'Waiting for a remote user to join...';
    else
      statusText = 'Connected to remote user, uid:$_remoteUid';

    return Text(
      statusText,
    );
  }

   Widget _remoteVideo() {



   if (_remoteUid != null) {
   return   Column(
     mainAxisAlignment: MainAxisAlignment.center,
   crossAxisAlignment: CrossAxisAlignment.center,
   children : [
   ClipOval(
   child: Image.network("https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8dXNlciUyMHByb2ZpbGV8ZW58MHx8MHx8fDA%3D",height: 100,)
   ),
     Text( "amna")
   ]
   );
   } else {
   return const Text(
   'Please wait for remote user to join',
   textAlign: TextAlign.center,
   );
   }
   }
  Widget _localVideo() {

    if (_isJoined) {
      return   Column(
          children : [
            ClipOval(
                child: Image.network("https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8dXNlciUyMHByb2ZpbGV8ZW58MHx8MHx8fDA%3D",height: 100,)
            ),
            Text( "Ali")
          ]
      );
    } else {
      return  const CircularProgressIndicator();
    }
  }



  showMessage(String message) {
    scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }
}
