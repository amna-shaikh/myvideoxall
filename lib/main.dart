import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:myvideoxall/pickup_layout.dart';
import 'package:myvideoxall/utils.dart';

import 'myvideo.dart';
import 'voice_call.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyDQsS3wxIOenFqQuVMAYSn39I9tbSc8HiE",
      appId: "1:168932673605:android:99256a593c5c3cd2793b2c",
      projectId: "newcallproject-91a38", messagingSenderId: '',
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

   @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  Widget build(BuildContext context) {
    return PickupLayout(
      scaffold: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[


              ElevatedButton(onPressed: (){
                CallUtils.dial(
                  context: context,
                );
               /* Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Myvideocall()),
                );*/
              }, child: Text("Video CALL")),

              ElevatedButton(onPressed: (){

                 Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const VoiceCall()),
                );
              }, child: Text("Voice CALL"))
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
