import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_dart/firebase_dart.dart';
import 'package:easy_splash_screen/easy_splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      title: 'Flutter Demo',
      theme: CupertinoThemeData(
        primaryColor: CupertinoColors.systemGreen,
      ),
      home: MySplashPage(),
    );
  }
}

class MySplashPage extends StatefulWidget {
  const MySplashPage({super.key});

  @override
  State<MySplashPage> createState() => _MySplashPageState();
}

class _MySplashPageState extends State<MySplashPage> {
  @override
  Widget build(BuildContext context) {
    return EasySplashScreen(
      logo: Image.file(
          File('assets/images/eriell_logo.png')
      ),
      navigator: const MyHomePage(title: 'ERIELL Demo App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late TextEditingController _loginController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    _loginController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return CupertinoPageScaffold(
        child: Column(
            children: <Widget> [
              const SizedBox(
                height: 50.0,
              ),
              //login
              CupertinoTextField(
                controller: _loginController,
              ),
              const SizedBox(
                height: 40.0,
              ),
              //password
              CupertinoTextField(
                controller: _passwordController,
              ),
              const SizedBox(
                height: 40.0,
              ),
              CupertinoButton(
                  child: const Text('Sign In'),
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => const DataView(),
                        ),
                    );
                  },
              )
            ],
        ),
    );
  }
}

class DataView extends StatefulWidget {
  const DataView({super.key});
  @override
  State<DataView> createState() => _DataViewState();
}

class _DataViewState extends State<DataView> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        child: OrientationBuilder(
          builder: (context, orientation) {
            return Center(
              child: orientation == Orientation.portrait
                  ? const _PortraitView() //The widget for portrait orientation.
                  : const _LandscapeView(), //The widget for landscape orientation.
            );
          },
        ),
    );
  }
}

class _PortraitView extends StatefulWidget {
  const _PortraitView({super.key});

  @override
  State<_PortraitView> createState() => _PortraitViewState();
}

class _PortraitViewState extends State<_PortraitView> {
  @override
  Widget build(BuildContext context) {
    return const Text('portrait view');
  }
}

class _LandscapeView extends StatefulWidget {
  const _LandscapeView({super.key});

  @override
  State<_LandscapeView> createState() => _LandscapeViewState();
}

class _LandscapeViewState extends State<_LandscapeView> {
  @override
  Widget build(BuildContext context) {
    return const Text('landscape view');
  }
}