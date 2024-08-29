// lib/main.dart
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:itunes_task/screens/itunes_search_screen.dart';
import 'package:itunes_task/view_models/itunes_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:root_checker_plus/root_checker_plus.dart';

import 'models/itunes_media.dart';


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ItunesViewModel(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
      title: 'iTunes Media App',

      home:

      SplashScreenWrapper()
    );
  }
}




class SplashScreenWrapper extends StatefulWidget {
  @override
  _SplashScreenWrapperState createState() => _SplashScreenWrapperState();
}

class _SplashScreenWrapperState extends State<SplashScreenWrapper> {

  bool rootedCheck = false;


  bool jailbreak = false;


  bool devMode = false;
  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 3), () async {

      if (Platform.isAndroid) {
        await androidRootChecker();
        await developerMode();
      } else if (Platform.isIOS) {
        await iosJailbreak();
      }


      if (rootedCheck || jailbreak) {

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => RootWarningScreen()),
        );
      } else {

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => ItunesSearchScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
     return SplashScreen();
       //Center(
    //     child: Platform.isAndroid
    //         ? Text('Running on Android\n\n Root Checker: $rootedCheck\n Developer Mode Enable:$devMode',style: TextStyle(color: Colors.white),)
    //         : Text('Running on iOS\n Jailbreak: $jailbreak \n',style: TextStyle(color: Colors.white)));
      //SplashScreen();
  }
  Future<void> androidRootChecker() async {
    try {
      rootedCheck = (await RootCheckerPlus.isRootChecker())!;
    } on PlatformException {
      rootedCheck = false;
    }
    if (!mounted) return;
    setState(() {
      rootedCheck = rootedCheck;
    });
  }

  Future<void> developerMode() async {
    try {
      devMode = (await RootCheckerPlus.isDeveloperMode())!;
    } on PlatformException {
      devMode = false;
    }
    if (!mounted) return;
    setState(() {
      devMode = devMode;
    });
  }

  Future<void> iosJailbreak() async {
    try {
      jailbreak = (await RootCheckerPlus.isJailbreak())!;
    } on PlatformException {
      jailbreak = false;
    }
    if (!mounted) return;
    setState(() {
      jailbreak = jailbreak;
    });
  }
}

class RootWarningScreen extends StatelessWidget {
  const RootWarningScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Rooted Mobile',style: TextStyle(color: Colors.white),),
    );
  }
}


class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              'https://upload.wikimedia.org/wikipedia/commons/thumb/d/df/ITunes_logo.svg/657px-ITunes_logo.svg.png',
              width: 100,
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),

          ],
        ),
      ),
    );
  }
}
