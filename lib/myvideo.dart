import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Myvideocall extends StatefulWidget {
  const Myvideocall({super.key});

  @override
  State<Myvideocall> createState() => _MyvideocallState();
}

class _MyvideocallState extends State<Myvideocall> {
  @override
  // Instantiate the client
  final AgoraClient client = AgoraClient(
    agoraConnectionData: AgoraConnectionData(
      appId: "a28be509a7404ebc9f42459393ba1cfa",
      channelName: "test",
      tempToken: "",
      uid: 0
    ),
  );

// Initialize the Agora Engine
  @override
  void initState() {
    super.initState();
    initAgora();
  }

  void initAgora() async {
    await client.initialize();
  }

// Build your layout
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              AgoraVideoViewer(client: client),
              AgoraVideoButtons(client: client),
            ],
          ),
        ),
      ),
    );
  }

}
