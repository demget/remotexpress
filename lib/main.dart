import 'dart:io';
import 'dart:ui';

import 'package:window_size/window_size.dart' as window;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:remotexpress/l10n.dart';

import 'package:remotexpress/pages/accessories.dart';
import 'package:remotexpress/pages/debug.dart';
import 'package:remotexpress/pages/launch.dart';
import 'package:remotexpress/pages/locomotive/locomotive.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    const size = Size(405, 700);
    window.setWindowMinSize(size);
  }

  runApp(App());
}

class App extends StatelessWidget {
  static const String title = 'remoteXpress';

  static const Color backgroundColor = Color.fromARGB(0xff, 33, 33, 47);
  static const Color primaryColor = Color.fromARGB(0xff, 125, 123, 250);
  static const Color primaryColorDark = Color.fromARGB(0xff, 60, 62, 107);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      themeMode: ThemeMode.light,
      localizationsDelegates: L10n.localizationsDelegates,
      supportedLocales: L10n.supportedLocales,
      theme: ThemeData(
        brightness: Brightness.light,
        canvasColor: Colors.transparent,
        backgroundColor: backgroundColor,
        primaryColor: primaryColor,
        primaryColorDark: primaryColorDark,
        colorScheme: ColorScheme.light(primary: primaryColor),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: backgroundColor,
          selectedItemColor: primaryColor,
          unselectedItemColor: Colors.white54,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: HomePage(title: title),
    );
  }
}

class HomePage extends StatefulWidget {
  final String title;

  HomePage({Key? key, required this.title}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool connected = true;
  late Widget bodyWidget;

  List<Widget> pages = <Widget>[];
  int selectedPage = 0;

  void _onNavigationItem(int index) {
    setState(() {
      selectedPage = index;
    });
  }

  @override
  void initState() {
    bodyWidget = LaunchPage(
      onLaunched: () {
        setState(() {
          connected = true;
          bodyWidget = Padding(
            padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
            child: IndexedStack(index: selectedPage, children: pages),
          );
        });
      },
    );

    pages.add(LocomotivePage());
    pages.add(AccessoriesPage());
    pages.add(DebugPage());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));

    return Scaffold(
      extendBody: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: [
              Color(0xff222239),
              Color(0xff292845),
            ],
          ),
        ),
        child: SafeArea(
          child: AnimatedSwitcher(
            duration: const Duration(seconds: 1),
            child: bodyWidget,
          ),
        ),
      ),
      bottomNavigationBar: connected
          ? ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
              child: BottomNavigationBar(
                elevation: 5,
                currentIndex: selectedPage,
                onTap: _onNavigationItem,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.train),
                    label: 'Locomotive',
                    tooltip: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.alt_route),
                    label: 'Accessories',
                    tooltip: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.amp_stories),
                    label: 'CV',
                    tooltip: '',
                  ),
                ],
              ),
            )
          : null,
    );
  }
}
