import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:google_fonts/google_fonts.dart';
import 'package:remotexpress/models/route.dart';
import 'package:remotexpress/pages/accessories/buttons.dart';

class AccessoryRoutes extends StatefulWidget {
  final List<Route> routes;

  AccessoryRoutes({required this.routes});

  @override
  _AccessoryRoutesState createState() => _AccessoryRoutesState();
}

class _AccessoryRoutesState extends State<AccessoryRoutes> {
  Widget headerRow(BuildContext context, Route route, [bool expanded = false]) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon(
          Icons.alt_route,
          color: Theme.of(context).primaryColor,
        ),
        Text(
          route.name,
          style: GoogleFonts.lato(
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
                          Container(
                            height: 40,
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: AccessoryButtons(),
                              // LocomotiveFunctions(
                              //   columns: 5,
                              //   rows: 1,
                              //   functions: List.generate(
                              //     5,
                              //     (i) => LocoFunction(i, i % 2 == 0),
                              //   ),
                              //   childBuilder: (f) => Text('A${f + 1}'),
                              // ),
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
