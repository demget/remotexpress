import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remotexpress/l10n.dart';
import 'package:remotexpress/widgets/logo.dart';

class DebugPage extends StatefulWidget {
  DebugPage({Key? key}) : super(key: key);

  @override
  _DebugPageState createState() => _DebugPageState();
}

class _DebugPageState extends State<DebugPage> {
  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Logo(),
            SizedBox(height: 20),
            Text(
              L10n.of(context)!.cvInProgress,
              style: GoogleFonts.lato(
                fontSize: 18,
                color: Colors.white,
              ),
            )
          ],
        ));

    // Column(
    //   mainAxisAlignment: MainAxisAlignment.start,
    //   children: [
    //     IntrinsicHeight(
    //       child: Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //         crossAxisAlignment: CrossAxisAlignment.stretch,
    //         children: [
    //           Expanded(
    //             child: TextField(
    //               style: TextStyle(fontSize: 15),
    //               textAlign: TextAlign.center,
    //               decoration: InputDecoration(labelText: "CV"),
    //               keyboardType: TextInputType.number,
    //               inputFormatters: <TextInputFormatter>[
    //                 FilteringTextInputFormatter.digitsOnly,
    //                 RangeTextInputFormatter(min: 0, max: 1024),
    //               ],
    //             ),
    //           ),
    //           SizedBox(width: 10),
    //           Expanded(
    //             child: TextField(
    //               style: TextStyle(fontSize: 15),
    //               textAlign: TextAlign.center,
    //               decoration: InputDecoration(labelText: "Value"),
    //               keyboardType: TextInputType.number,
    //               inputFormatters: <TextInputFormatter>[
    //                 FilteringTextInputFormatter.digitsOnly,
    //                 RangeTextInputFormatter(min: 0, max: 1024),
    //               ],
    //             ),
    //           ),
    //           SizedBox(width: 10),
    //           Expanded(
    //             child: Padding(
    //               padding: EdgeInsets.only(top: 15, bottom: 0),
    //               child: ElevatedButton(
    //                 onPressed: () {},
    //                 child: Text("PROGRAM!"),
    //               ),
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ],
    // );
  }
}
