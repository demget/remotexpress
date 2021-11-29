import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:network_info_plus/network_info_plus.dart';

import 'package:remotexpress/l10n.dart';
import 'package:remotexpress/net/station.dart';
import 'package:remotexpress/widgets/custom_dialog.dart';

class LaunchPage extends StatefulWidget {
  final void Function(Station)? onLaunched;

  LaunchPage({this.onLaunched});

  @override
  _LaunchPageState createState() => _LaunchPageState();
}

class _LaunchPageState extends State<LaunchPage> with TickerProviderStateMixin {
  late AnimationController iconAnimation;
  _LaunchStatus status = _LaunchStatus();

  Future<Station?> launch() async {
    // 1. Checking WiFi
    setState(() => this.status.next());

    final network = NetworkInfo();
    final wifiName = await network.getWifiName();

    if (wifiName != 'dccXpress') {
      CustomDialog.show(
        context,
        title: L10n.of(context)!.errorBadWiFiTitle,
        content: L10n.of(context)!.errorBadWiFiContent,
        positiveText: L10n.of(context)!.errorBadWiFiPositive,
        onPositivePressed: retryLaunch,
      );
      return null;
    }

    // 2. Connecting to the socket
    setState(() => this.status.next());

    try {
      return await Station.connect();
    } catch (e) {
      CustomDialog.show(
        context,
        title: L10n.of(context)!.errorBadConnectionTitle,
        content: L10n.of(context)!.errorBadConnectionContent,
        positiveText: L10n.of(context)!.errorBadConnectionPositive,
        onPositivePressed: retryLaunch,
      );

      print(e);
      return null;
    }
  }

  Future tryLaunch() async {
    final station = await launch();
    if (station != null) widget.onLaunched?.call(station);
  }

  Future retryLaunch() async {
    Navigator.of(context).pop();
    status.reset();
    await tryLaunch();
  }

  @override
  void initState() {
    iconAnimation = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
      lowerBound: 10.0,
      upperBound: 80.0,
    )..forward();

    iconAnimation.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        await tryLaunch();
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    iconAnimation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        AnimatedBuilder(
          animation: iconAnimation,
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
                    size: iconAnimation.value,
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
                    fontSize: iconAnimation.value - 20,
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
              status.text(context) + "...",
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
  static const statuses = [
    'initializing',
    'checking',
    'connecting',
    'reading',
  ];

  late String current;
  int index = 0;

  _LaunchStatus() {
    next();
  }

  void next() {
    if (index == statuses.length) return;
    current = statuses[index];
    index += 1;
  }

  void reset() {
    index = 0;
  }

  String value() {
    return current;
  }

  String text(BuildContext context) {
    switch (current) {
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
