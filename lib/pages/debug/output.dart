import 'package:flutter/material.dart' hide Route;

class DebugOutput extends StatefulWidget {
  final List<List<int>> output;

  DebugOutput({
    required this.output,
  });

  @override
  _DebugOutputState createState() => _DebugOutputState();
}

class _DebugOutputState extends State<DebugOutput> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: BouncingScrollPhysics(),
      children: [
        ...widget.output.map<Container>(
          (command) => Container(
            margin: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
            padding: EdgeInsets.all(10),
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
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Icon(
                    Icons.data_object,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      command
                          .map((i) =>
                              '0x' +
                              i.toRadixString(16).padLeft(2, '0').toUpperCase())
                          .join(' '),
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
