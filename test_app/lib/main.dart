import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:mrx_charts/mrx_charts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spreadsheet_table/spreadsheet_table.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:test_app/hive_classes/hive_auth.dart';
import 'package:path_provider/path_provider.dart';

import 'package:icons_launcher/cli_commands.dart';
import 'package:icons_launcher/utils/cli_logger.dart';
import 'package:icons_launcher/utils/constants.dart';
//import 'package:icons_launcher/utils/flavor_helper.dart';
import 'package:icons_launcher/utils/icon.dart';
import 'package:icons_launcher/utils/template.dart';
import 'package:icons_launcher/utils/utils.dart';

void main() async {
  runApp(const MyApp());
  final directory = getApplicationDocumentsDirectory();
  await Hive.initFlutter((await directory).path + "/db");
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
      navigator: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return const CupertinoPageScaffold(
      child: _SignForm(),
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
              100 + Random().nextInt(155),
              Random().nextInt(pow(2, 8).ceil()),
              Random().nextInt(pow(2, 8).ceil()),
              Random().nextInt(pow(2, 8).ceil())),
          label: mapItem.key));
    }
    return result;
  }
}

class PersonCubit extends Cubit<String> {
  PersonCubit(initialData) : super(initialData);
}

class DataView extends StatefulWidget {
  const DataView({super.key, required this.userName});

  final String userName;

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
      child: Builder(builder: (BuildContext context) {
        return BlocProvider(
            create: (_) => PersonCubit(widget.userName),
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
      }),
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
    return BlocBuilder<PersonCubit, String>(
        builder: (context, state) {
          return CupertinoPageScaffold(
            navigationBar: const CupertinoNavigationBar(
              middle: Text('Portrait View'),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 40.0,
                  ),
                  Text("Hello, $state!"),
                  const Center(
                    child: _Chart(),
                    //child: Text('Place for chart'),
                  ),
                  const SizedBox(
                    height: 40.0,
                  ),
                  const Center(
                    child: _Table(),
                  ),
                ],
              ),
            ),
          );
        });
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
      return Container(
        alignment: Alignment.center,
        constraints: BoxConstraints.expand(
          width: MediaQuery.of(context).size.width / 2,
          height: MediaQuery.of(context).size.height / 2,
        ),
        child: SpreadsheetTable(
          cellWidth: MediaQuery.of(context).size.width / 4,
          cellHeight: MediaQuery.of(context).size.height / (3 * state.length),
          colCount: 1,
          rowsCount: state.length,
          colHeaderBuilder: (_, __) => const FittedBox(
            fit: BoxFit.contain,
            child: Text('Value'),
          ),
          rowHeaderBuilder: (_, index) {
            return FittedBox(
              fit: BoxFit.contain,
              child: Text(state.keys.elementAt(index)),
            );
          },
          cellBuilder: (_, int row, __) {
            return FittedBox(
              fit: BoxFit.contain,
              child: Text(state.values.elementAt(row).toString()),
            );
          },
          legendBuilder: (_) {
            return const FittedBox(
              fit: BoxFit.contain,
              child: Text('Example data'),
            );
          },
        ),
      );
    });
  }
}

class _SignForm extends StatefulWidget {
  const _SignForm({super.key});

  @override
  State<_SignForm> createState() => _SignFormState();
}

class _SignFormState extends State<_SignForm> {
  late TextEditingController _loginController;
  late TextEditingController _passwordController;
  late Box<dynamic> authBox;

  @override
  void initState() {
    initAsync();
    _loginController = TextEditingController();
    _passwordController = TextEditingController();
    Hive.registerAdapter(PersonAdapter());
    super.initState();
  }

  void initAsync() async {
    authBox = await Hive.openBox('Persons');
  }

  void userCheck(String login, String password, Box<dynamic> authBox) {
    if (authBox.containsKey(login) && (authBox.get(login).password == password)) {
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
          builder: (context) => DataView(
            userName: login,
          ),
        ),
      );
    }
    if (authBox.containsKey(login) && !(authBox.get(login) == password)) {
      showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: const Text('User error'),
          content: const Text('Wrong password'),
          actions: <CupertinoDialogAction>[
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('close'),
            ),
          ],
        ),
      );
    }
    if (!authBox.containsKey(login)) {
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
          builder: (context) {
            return _CreateUserForm(authBox: authBox);
          },
        ),
      ); //pop-up with registration form
    }
  }

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          height: 50.0,
        ),
        //login
        CupertinoTextField(
          placeholder: "Login",
          controller: _loginController,
        ),
        const SizedBox(
          height: 40.0,
        ),
        //password
        CupertinoTextField(
          placeholder: "Password",
          controller: _passwordController,
        ),
        const SizedBox(
          height: 40.0,
        ),
        CupertinoButton(
          child: const Text('Sign In'),
          onPressed: () {
            userCheck(_loginController.text, _passwordController.text, authBox);
          },
        ),
      ],
    );
  }
}

class _CreateUserForm extends StatefulWidget {
  const _CreateUserForm({super.key, required this.authBox});

  final Box<dynamic> authBox;
  @override
  State<_CreateUserForm> createState() => _CreateUserFormState();
}

class _CreateUserFormState extends State<_CreateUserForm> {
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

  void createUser(String login, String password, Box<dynamic> authBox) {
    if (authBox.containsKey(login)) {
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
          builder: (context) => CupertinoPageScaffold(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                SizedBox(
                  height: 40.0,
                ),
                Text("User with this name already exists"),
                _SignForm(),
              ],
            ),
          ),
        ),
      );
    } else {
      final person = Person(login: login, password: password);
      widget.authBox.put(login, person);
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
          builder: (context) => DataView(
            userName: login,
          ),
        ),
      );
    }
  }

  @override
  Widget build(context) {
    return CupertinoPageScaffold(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 40.0,
          ),
          const Text("Create new user"),
          const SizedBox(
            height: 40.0,
          ),
          CupertinoTextField(
            placeholder: "Login",
            controller: _loginController,
          ),
          const SizedBox(
            height: 40.0,
          ),
          CupertinoTextField(
            placeholder: "Password",
            controller: _passwordController,
          ),
          const SizedBox(
            height: 40.0,
          ),
          CupertinoButton(
            child: const Text('Create user'),
            onPressed: () {
              createUser(_loginController.text, _passwordController.text,
                  widget.authBox);
            },
          )
        ],
      ),
    );
  }
}
