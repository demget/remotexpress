import 'dart:convert';

import 'package:flutter/material.dart' hide Route;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:remotexpress/widgets/custom_dialog.dart';

import 'package:remotexpress/models/accessory.dart';
import 'package:remotexpress/models/group.dart';
import 'package:remotexpress/models/route.dart';

import 'package:remotexpress/pages/accessories/control.dart';
import 'package:remotexpress/pages/accessories/groups.dart';
import 'package:remotexpress/pages/accessories/routes.dart';

import 'package:remotexpress/net/station.dart';

class AccessoriesPage extends StatefulWidget {
  final Station station;

  AccessoriesPage(this.station);

  late _AccessoriesPageState _state;

  @override
  _AccessoriesPageState createState() {
    _state = _AccessoriesPageState(station);
    return _state;
  }

  void floatingButtonAction() {
    _state.onAddRoute();
  }
}

class _AccessoriesPageState extends State<AccessoriesPage> {
  final Station station;
  late SharedPreferences prefs;

  _AccessoriesPageState(this.station);

  static final defaultAccessories = List.generate(
    1024,
    (i) => Accessory(i + 1),
  );
  static final defaultGroups = [
    Group('Стрілки', Icons.compare_arrows.codePoint),
    Group('Світло', Icons.lightbulb.codePoint),
    Group('Звук', Icons.volume_up.codePoint),
    Group('Семафори', Icons.traffic.codePoint),
    Group('Шлагбауми', Icons.fence.codePoint),
  ];
  static final defaultRoutes = [
    Route(
      'Тестовий маршрут',
      [
        Accessory(3, false),
        Accessory(2, true),
        Accessory(4, true),
        Accessory(5, false),
      ],
    ),
  ];

  List<Accessory> accessories = defaultAccessories;
  List<Group> groups = [];
  List<Route> routes = [];

  late String selectedGroup;
  late String selectedRoute;

  void setPrefs() {
    Future set(String key, Object object) async {
      return await prefs.setString(key, jsonEncode(object));
    }

    Future.delayed(Duration.zero, () async {
      await set('groups', groups);
      await set('routes', routes);
    });
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      final prefs = await SharedPreferences.getInstance();

      Future setIfNotContains(String key, Object object) async {
        if (!prefs.containsKey(key)) {
          await prefs.setString(key, jsonEncode(object));
        }
      }

      List<T> decodeList<T>(String key, T Function(dynamic) decode) {
        return jsonDecode(prefs.getString(key)!).map<T>(decode).toList();
      }

      // First start
      await setIfNotContains('groups', defaultGroups);
      await setIfNotContains('routes', defaultRoutes);

      groups = decodeList(
        'groups',
        (json) => Group.fromJson(json),
      );
      routes = decodeList(
        'routes',
        (json) => Route.fromJson(json),
      );

      selectedGroup = groups[0].name;
      selectedRoute = routes[0].name;

      setState(() {});
    });

    super.initState();
  }

  void onToggle(int i) {
    final accessory = accessories[i];
    setState(() => accessory.toggle());
    station.updateAccessory(accessory);
  }

  void onAddToGroup(int i) {
    final accessory = accessories[i];

    CustomDialog.show(
      context,
      title: 'Виберіть групу',
      icon: Icons.add_to_photos,
      child: StatefulBuilder(
        builder: (builder, setState) => DropdownButton(
          value: selectedGroup,
          isExpanded: true,
          dropdownColor: Colors.white,
          items: groups
              .map<DropdownMenuItem<String>>(
                (group) => DropdownMenuItem(
                  child: Text(group.name),
                  value: group.name,
                ),
              )
              .toList(),
          onChanged: (group) {
            setState(() => selectedGroup = group.toString());
          },
        ),
      ),
      positiveText: 'Додати',
      negativeText: 'Видалити',
      onPositivePressed: () {
        setState(() {
          final group = groups.where((g) => g.name == selectedGroup).first;
          if (!group.accessories.contains(accessory)) {
            group.accessories.add(accessory);
            setPrefs();
          }
        });
        CustomDialog.pop(context);
      },
      onNegativePressed: () {
        setState(() {
          final group = groups.where((g) => g.name == selectedGroup).first;
          group.accessories.remove(accessory);
          setPrefs();
        });
        CustomDialog.pop(context);
      },
    );
  }

  void onAddToRoute(int i) {
    final accessory = accessories[i];

    CustomDialog.show(
      context,
      title: 'Виберіть маршрут',
      icon: Icons.alt_route,
      child: DropdownButton(
        value: selectedRoute,
        isExpanded: true,
        dropdownColor: Colors.white,
        items: routes
            .map<DropdownMenuItem<String>>(
              (route) => DropdownMenuItem(
                child: Text(route.name),
                value: route.name,
              ),
            )
            .toList(),
        onChanged: (route) {
          setState(() => selectedRoute = route.toString());
        },
      ),
      positiveText: 'Додати',
      negativeText: 'Видалити',
      onPositivePressed: () {
        setState(() {
          final route = routes.where((r) => r.name == selectedRoute).first;
          if (!route.turnouts.contains(accessory)) {
            route.turnouts.add(accessory);
            setPrefs();
          }
        });
        CustomDialog.pop(context);
      },
      onNegativePressed: () {
        setState(() {
          final route = routes.where((r) => r.name == selectedRoute).first;
          final turnout = route.turnouts.where((t) => t.a == accessory.a).first;
          route.turnouts.remove(turnout);
          setPrefs();
        });
        CustomDialog.pop(context);
      },
    );
  }

  void onPlayRoute(Route route) {
    route.turnouts.forEach((accessory) {
      station.updateAccessory(accessory);
    });
  }

  void onAddRoute() {
    final TextEditingController controller = TextEditingController();

    CustomDialog.show(
      context,
      title: 'Введіть назву маршруту',
      icon: Icons.alt_route,
      child: StatefulBuilder(
        builder: (builder, setState) => TextField(
          controller: controller,
          decoration: InputDecoration(hintText: 'Назва'),
          onChanged: (v) {
            setState(() {});
          },
        ),
      ),
      positiveText: 'Додати',
      negativeText: 'Відміна',
      onPositivePressed: () {
        setState(() => routes.add(Route(controller.value.text)));
        setPrefs();
        CustomDialog.pop(context);
      },
      onNegativePressed: () => CustomDialog.pop(context),
    );
  }

  void onDeleteRoute(Route route) {
    CustomDialog.error(
      context,
      title: 'Видалення маршруту',
      content: 'Ви впевнені, що хочете видалити ${route.name}?',
      positiveText: 'Видалити',
      negativeText: 'Відміна',
      onPositivePressed: () {
        setState(() => routes.remove(route));
        setPrefs();
        CustomDialog.pop(context);
      },
      onNegativePressed: () => CustomDialog.pop(context),
    );
  }

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
              onToggle: onToggle,
              onAddToGroup: onAddToGroup,
              onAddToRoute: onAddToRoute,
            ),
          ),
          Expanded(
            flex: 2,
            child: AccessoryGroups(
              groups: groups,
              onToggle: onToggle,
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            flex: 3,
            child: AccessoryRoutes(
              routes: routes,
              onPlay: onPlayRoute,
              onDelete: onDeleteRoute,
            ),
          ),
        ],
      ),
    );
  }
}
