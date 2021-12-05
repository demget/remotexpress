import 'package:flutter/material.dart' hide Route;
import 'package:remotexpress/net/loco.dart';
import 'package:remotexpress/pages/accessories/control.dart';
import 'package:remotexpress/pages/accessories/groups.dart';
import 'package:remotexpress/pages/accessories/routes.dart';
import 'package:remotexpress/net/station.dart';
import 'package:remotexpress/models/route.dart';

class AccessoriesPage extends StatefulWidget {
  final Station station;

  AccessoriesPage(this.station);

  @override
  _AccessoriesPageState createState() => _AccessoriesPageState();
}

class _AccessoriesPageState extends State<AccessoriesPage> {
  List<bool> accessories = List.generate(1024, (i) => false);

  List<Route> routes = [
    Route('Маршрут #1'),
    Route('Маршрут #2'),
    Route('Маршрут #3'),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: AccessoriesControl(
              accessories: accessories,
              onToggle: (i) {
                setState(() => accessories[i] = !accessories[i]);
              },
              onAdd: (i) {},
            ),
          ),
          Expanded(
            flex: 2,
            child: AccessoryGroups(),
          ),
          SizedBox(height: 10),
          Expanded(
            flex: 3,
            child: AccessoryRoutes(routes: routes),
          ),
        ],
      ),
    );
  }
}
