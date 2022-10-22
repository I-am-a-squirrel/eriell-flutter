import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
import 'package:firebase_dart/firebase_dart.dart';
import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:mrx_charts/mrx_charts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spreadsheet_table/spreadsheet_table.dart';

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
      logo: Image.asset('assets/images/eriell_logo.png'),
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
        children: <Widget>[
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

class DataCubit extends Cubit<Map<String, double>> {
  DataCubit(initialData) : super(initialData);

  List<List<ChartGroupPieDataItem>> toPie(state) {
    List<List<ChartGroupPieDataItem>> result = [[]];
    for (MapEntry mapItem in state.entries) {
      result[0].add(ChartGroupPieDataItem(
          amount: mapItem.value,
          color: Color.fromARGB(
              255,
              Random().nextInt(pow(2, 8).ceil()),
              Random().nextInt(pow(2, 8).ceil()),
              Random().nextInt(pow(2, 8).ceil())),
          label: mapItem.key));
    }
    return result;
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
    return BlocProvider(
      create: (_) => DataCubit({
        'first': 2.0,
        'second': 3.0,
        'third': 5.0,
        'fourth': 7.0,
        'fifth': 11.0,
      }),
      child: CupertinoPageScaffold(
        child: OrientationBuilder(
          builder: (context, orientation) {
            return Center(
              child: orientation == Orientation.portrait
                  ? const _PortraitView() //The widget for portrait orientation.
                  : const _LandscapeView(), //The widget for landscape orientation.
            );
          },
        ),
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
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Portrait View'),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Center(
              child: _Chart(),
              //child: Text('Place for chart'),
            ),
            SizedBox(
              height: 40.0,
            ),
            Center(
              child: _Table(),
            ),
          ],
        ),
      ),
    );
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
    return const _Chart();
  }
}

class _Chart extends StatefulWidget {
  const _Chart({super.key});

  @override
  State<_Chart> createState() => _ChartState();
}

class _ChartState extends State<_Chart> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DataCubit, Map<String, double>>(
      builder: (context, state) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                constraints: BoxConstraints.expand(
                  width: MediaQuery.of(context).size.width / 4,
                  height: MediaQuery.of(context).size.height / 4,
                ),
                child: Chart(
                  layers: [
                    ChartGroupPieLayer(
                        items: context.read<DataCubit>().toPie(state),
                        settings: const ChartGroupPieSettings())
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Table extends StatefulWidget {
  const _Table({super.key});

  @override
  State<_Table> createState() => _TableState();
}

class _TableState extends State<_Table> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DataCubit, Map<String, double>>(
        builder: (context, state) {
      return SpreadsheetTable(
          colCount: 1,
          rowsCount: state.length,
          colHeaderBuilder: (_, __) => const Text('Value'),
          rowHeaderBuilder: (_, index) {
            return Text(state.keys.elementAt(index));
          },
          cellBuilder: (_, int row, __) {
            return Center(
              child: Text(state.values.elementAt(row).toString()),
            );
          },
          legendBuilder: (_) {
            return const Text('Example Data');
          });
    });
  }
}
