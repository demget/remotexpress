import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:google_fonts/google_fonts.dart';
import 'package:remotexpress/l10n.dart';
import 'package:remotexpress/models/route.dart';
import 'package:remotexpress/pages/accessories/buttons.dart';

class AccessoryRoutes extends StatefulWidget {
  final List<Route> routes;
  final void Function(Route route) onPlay, onDelete;

  AccessoryRoutes({
    required this.routes,
    required this.onPlay,
    required this.onDelete,
  });

  @override
  _AccessoryRoutesState createState() => _AccessoryRoutesState();
}

class _AccessoryRoutesState extends State<AccessoryRoutes> {
  Widget headerRow(BuildContext context, Route route, [bool expanded = false]) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: Icon(expanded ? Icons.play_arrow : Icons.alt_route),
          color: Theme.of(context).primaryColor,
          onPressed: () =>
              expanded ? widget.onPlay(route) : widget.onDelete(route),
        ),
        Text(
          route.name,
          style: TextStyle(
            color: Colors.grey[300],
            fontSize: 16,
          ),
        ),
        ExpandableButton(
          child: Icon(
            expanded ? Icons.expand_less : Icons.expand_more,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: BouncingScrollPhysics(),
      children: [
        ...widget.routes.map<ExpandableNotifier>(
          (route) => ExpandableNotifier(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: ScrollOnExpand(
                child: Column(
                  children: [
                    Expandable(
                      collapsed: headerRow(context, route),
                      expanded: Column(
                        children: [
                          headerRow(context, route, true),
                          SizedBox(height: 5),
                          route.turnouts.length != 0
                              ? Container(
                                  height: 40,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: AbsorbPointer(
                                      child: AccessoryButtons(
                                        accessories: route.turnouts,
                                        childBuilder: (a) => Text('A$a'),
                                        onToggle: null, // TODO
                                      ),
                                    ),
                                  ),
                                )
                              : Padding(
                                  padding: EdgeInsets.only(bottom: 3, left: 20),
                                  child: Text(
                                    L10n.of(context)!.accessoriesEmpty,
                                    style: TextStyle(
                                      color: Colors.grey[300],
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
