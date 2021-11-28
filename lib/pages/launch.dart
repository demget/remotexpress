import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:network_info_plus/network_info_plus.dart';

import 'package:remotexpress/l10n.dart';
import 'package:remotexpress/widgets/custom_dialog.dart';

class LaunchPage extends StatefulWidget {
  final Function? onLaunched;

  LaunchPage({
    Key? key,
    this.onLaunched,
  }) : super(key: key);

  @override
  _LaunchPageState createState() => _LaunchPageState();
}

class _LaunchPageState extends State<LaunchPage> with TickerProviderStateMixin {
  late AnimationController _iconAnimation;
  _LaunchStatus _status = _LaunchStatus();

  Future<bool> launch() async {
    final network = NetworkInfo();
    final wifiName = await network.getWifiName();

    if (wifiName != 'dccremote') {
      showGeneralDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.black54,
        transitionDuration: Duration(milliseconds: 400),
        transitionBuilder: (context, a1, a2, child) {
          return ScaleTransition(
            scale: CurvedAnimation(
              parent: a1,
              curve: Curves.elasticOut,
              reverseCurve: Curves.easeOutCubic,
            ),
            child: CustomDialog(
              icon: Icon(Icons.error, size: 35, color: Colors.white),
              title: L10n.of(context)!.errorBadWiFiTitle,
              content: L10n.of(context)!.errorBadWiFiContent,
              positiveText: L10n.of(context)!.errorBadWiFiPositive,
              negativeText: L10n.of(context)!.errorBadWiFiNegative,
              onPositivePressed: () {
                Navigator.of(context).pop();
              },
              onNegativePressed: () {
                // exit(0);
              },
            ),
          );
        },
        pageBuilder: (context, a1, a2) => SizedBox(),
      );
      return false;
    }

    return false;
  }

  @override
  void initState() {
    super.initState();

    _iconAnimation = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
      lowerBound: 10.0,
      upperBound: 80.0,
    )..forward();

    _iconAnimation.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        setState(() => _status.next());
        // await Future.delayed(Duration(seconds: 1));
        setState(() => _status.next());
        // await Future.delayed(Duration(seconds: 1));
        setState(() => _status.next());
        // await Future.delayed(Duration(seconds: 1));

        if (widget.onLaunched != null) {
          widget.onLaunched!();
        }
        // await launch();
      }
    });
  }

  @override
  void dispose() {
    _iconAnimation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        AnimatedBuilder(
          animation: _iconAnimation,
          builder: (context, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    Icons.train,
                    size: _iconAnimation.value,
                    color: Theme.of(context).primaryColorDark,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20.0),
                ),
                Text(
                  "Xpress",
                  style: GoogleFonts.lato(
                    color: Colors.grey[200],
                    fontWeight: FontWeight.bold,
                    fontSize: _iconAnimation.value - 20,
                  ),
                ),
              ],
            );
          },
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CircularProgressIndicator(),
            Padding(padding: EdgeInsets.only(top: 20)),
            Text(
              _status.text(context) + "...",
              style: GoogleFonts.lato(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 30)),
          ],
        ),
      ],
    );
  }
}

class _LaunchStatus {
  static const _statuses = [
    'initializing',
    'checking',
    'connecting',
    'reading',
  ];

  late String _current;
  int _index = 0;

  _LaunchStatus() {
    next();
  }

  void next() {
    if (_index == _statuses.length) return;
    _current = _statuses[_index];
    _index += 1;
  }

  String value() {
    return _current;
  }

  String text(BuildContext context) {
    switch (_current) {
      case 'initializing':
        return L10n.of(context)!.launchStatusInitializing;
      case 'checking':
        return L10n.of(context)!.launchStatusChecking;
      case 'connecting':
        return L10n.of(context)!.launchStatusConnecting;
      case 'reading':
        return L10n.of(context)!.launchStatusReading;
    }
    return '';
  }
}
