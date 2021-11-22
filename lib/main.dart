import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remotexpress/pages/accessories.dart';
import 'package:remotexpress/pages/debug.dart';
import 'package:remotexpress/pages/locomotive.dart';
import 'package:window_size/window_size.dart' as window;

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    const size = Size(397, 697);
    window.setWindowMinSize(size);
    window.setWindowMaxSize(size);
  }

  runApp(App());
}

class App extends StatelessWidget {
  static const String title = 'remoteXpress';

  static const Color backgroundColor = Color.fromARGB(0xff, 34, 34, 57);
  // static const Color backgroundColor = Color.fromARGB(0xff, 41, 40, 69);
  static const Color primaryColor = Color.fromARGB(0xff, 125, 123, 250);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      themeMode: ThemeMode.light,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: primaryColor,
        scaffoldBackgroundColor: backgroundColor,
        canvasColor: Colors.transparent,
        primaryTextTheme: TextTheme(
          headline6: GoogleFonts.lato(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        appBarTheme: AppBarTheme(
          elevation: 0,
          backgroundColor: backgroundColor,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: HomePage(title: title),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const _debugPageIndex = 2;

  List<Widget> _pages = <Widget>[];
  int _selectedPage = 0;

  void _onNavigationItem(int index) {
    setState(() {
      _selectedPage = index;
    });
  }

  @override
  void initState() {
    _pages.add(LocomotivePage());
    _pages.add(AccessoriesPage());
    _pages.add(DebugPage());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(widget.title),
      //   // centerTitle: true,
      //   elevation: AppBarTheme.of(context).elevation,
      //   actions: [
      //     // IconButton(
      //     //   icon: Icon(Icons.bug_report),
      //     //   onPressed: () => _onNavigationItem(_debugPageIndex),
      //     // ),
      //     // IconButton(
      //     //   icon: Icon(Icons.keyboard_voice),
      //     //   color: Theme.of(context).primaryColor,
      //     //   focusColor: Colors.grey,
      //     //   autofocus: true,
      //     //   onPressed: () {},
      //     // ),
      //   ],
      // ),
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
        child: Padding(
          padding: EdgeInsets.all(7),
          child: IndexedStack(
            index: _selectedPage,
            children: _pages,
          ),
        ),
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
        child: BottomNavigationBar(
          backgroundColor: Color.fromARGB(0xff, 33, 33, 47),
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Colors.white54,
          elevation: 5,
          currentIndex: _selectedPage,
          onTap: _onNavigationItem,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.train),
              label: 'Locomotive',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.alt_route),
              label: 'Accessories',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.amp_stories),
              label: 'CV',
            ),
          ],
        ),
      ),
    );
  }
}
