import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:remotexpress/formatters/range.dart';
import 'package:remotexpress/l10n.dart';
import 'package:remotexpress/pages/locomotive/functions.dart';

import 'package:remotexpress/net/loco.dart';
import 'package:remotexpress/net/station.dart';
import 'package:remotexpress/widgets/toggle_button.dart';

class AccessoriesPage extends StatefulWidget {
  final Station station;

  AccessoriesPage(this.station);

  @override
  _AccessoriesPageState createState() => _AccessoriesPageState();
}

class _AccessoriesPageState extends State<AccessoriesPage> {
  List<bool> items = [false];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        //   IntrinsicHeight(
        //       child: Row(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     crossAxisAlignment: CrossAxisAlignment.stretch,
        //     children: [
        //       Expanded(
        //         child: TextField(
        //           style: TextStyle(
        //             fontSize: 15,
        //             color: Colors.grey[300],
        //           ),
        //           textAlign: TextAlign.center,
        //           decoration: InputDecoration(
        //             labelText: L10n.of(context)!.accessoryLabel,
        //             // focusColor: Colors.grey[400],
        //           ),
        //           keyboardType: TextInputType.number,
        //           inputFormatters: [
        //             FilteringTextInputFormatter.digitsOnly,
        //             RangeTextInputFormatter(min: 0, max: 1024),
        //           ],
        //         ),
        //       ),
        //       SizedBox(width: 10),
        //       Expanded(
        //         child: ToggleButton(
        //           on: false,
        //           child: Text('OFF'),
        //           onPressed: () {},
        //         ),
        //       ),
        //     ],
        //   )),
        //   Container(
        //     height: 200,
        //     alignment: Alignment.center,
        //     child: LocomotiveFunctions(
        //       columns: 5,
        //       rows: 4,
        //       functions: List.generate(64, (i) => LocoFunction(i)),
        //       onToggle: (a) {},
        //       childBuilder: (a) => Text('A${a + 1}'),
        //     ),
        //   ),
      ],
    );

    // return SingleChildScrollView(
    //   child: Container(
    //     child: ExpansionPanelList(
    //       expansionCallback: (int index, bool expanded) {
    //         setState(() {
    //           items[index] = !expanded;
    //         });
    //       },
    //       children: items.map<ExpansionPanel>((bool expanded) {
    //         return ExpansionPanel(
    //           headerBuilder: (BuildContext context, bool isExpanded) {
    //             return ListTile(
    //               title: Text('Test'),
    //               tileColor: Theme.of(context).backgroundColor,

    //               // shape: RoundedRectangleBorder(
    //               //   borderRadius: BorderRadius.circular(100),
    //               // ),
    //             );
    //           },
    //           body: ListTile(
    //             title: Text('Expanded'),
    //             subtitle: Text('Delete'),
    //             trailing: Icon(Icons.delete),
    //             onTap: () {},
    //           ),
    //           isExpanded: expanded,
    //         );
    //       }).toList(),
    //     ),
    //   ),
    // );
  }
}
