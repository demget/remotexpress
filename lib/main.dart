import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:remotexpress/pages/locomotive.dart';
import 'package:window_size/window_size.dart' as window;

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    const size = Size(397, 697); // 737);
    window.setWindowMinSize(size);
    window.setWindowMaxSize(size);
  }

  runApp(App());
}

class App extends StatelessWidget {
  static const String title = 'remoteXpress';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      themeMode: ThemeMode.light,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.green,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.orange,
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
    _pages.add(LocomotivePage());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        elevation: 5,
        actions: [
          IconButton(
            icon: Icon(Icons.keyboard_voice),
            onPressed: () {},
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedPage,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
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
        selectedItemColor: Theme.of(context).primaryColor,
        currentIndex: _selectedPage,
        onTap: _onNavigationItem,
      ),
    );
  }
}
