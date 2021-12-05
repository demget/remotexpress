import 'package:flutter/material.dart' hide Route;
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:expandable/expandable.dart';
import 'package:remotexpress/l10n.dart';
import 'package:remotexpress/formatters/range.dart';
import 'package:remotexpress/net/loco.dart';
import 'package:remotexpress/pages/locomotive/functions.dart';
import 'package:remotexpress/widgets/toggle_button.dart';
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
    Route('Маршрут #1', [
      LocoFunction(3, true),
      LocoFunction(4, false),
      LocoFunction(2, true),
    ]),
  ];

  TextEditingController controller = TextEditingController();

  bool currentAccessory() {
    int i = (int.tryParse(controller.value.text) ?? 1) - 1;
    if (i < 0 || i >= accessories.length) return false;
    return accessories[i];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20, bottom: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      controller: controller,
                      onChanged: (_) {
                        setState(() {});
                      },
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[300],
                      ),
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        RangeTextInputFormatter(min: 0, max: 1024),
                      ],
                      decoration: InputDecoration(
                        labelText: L10n.of(context)!.accessoryLabel,
                        labelStyle: TextStyle(color: Colors.grey[400]),
                        floatingLabelStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                        prefixIcon: Icon(
                          Icons.memory,
                          size: 28,
                          color: Theme.of(context).primaryColor,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[400]!),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    flex: 1,
                    child: ToggleButton(
                      on: currentAccessory(),
                      child: Text(currentAccessory() ? 'ON' : 'OFF'),
                      onPressed: () {
                        int i = (int.tryParse(controller.value.text) ?? 1) - 1;
                        if (i < 0 || i >= accessories.length) return;
                        setState(() {
                          accessories[i] = !accessories[i];
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    flex: 1,
                    child: Tooltip(
                      message: L10n.of(context)!.addToGroupTooltip,
                      child: ToggleButton(
                        on: false,
                        child: Icon(Icons.add_to_photos),
                        onPressed: () {},
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Swiper(
              itemBuilder: (BuildContext context, int index) {
                final title = [
                  'Стрілки',
                  'Світло',
                  'Звук',
                ][index];
                final icon = [
                  Icons.compare_arrows,
                  Icons.lightbulb,
                  Icons.volume_up,
                ][index];

                final horizontal = true;

                final planetThumbnail = Container(
                  margin: EdgeInsets.symmetric(vertical: 16.0),
                  alignment: FractionalOffset.centerLeft,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Theme.of(context).primaryColor,
                    // Color.fromARGB(0xff, 77, 172, 100),
                    child: IconButton(
                      icon: Icon(icon),
                      iconSize: 40,
                      color: Colors.white,
                      onPressed: () {},
                    ),
                  ),
                );

                final planetCardContent = Container(
                  margin: EdgeInsets.symmetric(vertical: 16),
                  constraints: BoxConstraints.expand(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(height: 4.0),
                      Padding(
                        padding: EdgeInsets.only(left: 40),
                        child: Text(
                          title,
                          style: GoogleFonts.lato(
                            color: Colors.white,
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                      Container(height: 10.0),
                      Container(
                        height: 40,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          child: LocomotiveFunctions(
                            columns: 6,
                            rows: 1,
                            // offset: index + 1,
                            functions: List.generate(
                              12,
                              (i) => LocoFunction(i),
                            ),
                            onToggle: (_) {},
                            childBuilder: (f) => Text('A${f + 1}'),
                          ),
                        ),
                      ),
                    ],
                  ),
                );

                final planetCard = Container(
                  child: planetCardContent,
                  height: 124,
                  padding: EdgeInsets.only(left: 35, right: 25),
                  margin: EdgeInsets.only(left: 30),
                  decoration: BoxDecoration(
                    color: Theme.of(context).backgroundColor,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10.0,
                        offset: Offset(0.0, 10.0),
                      ),
                    ],
                  ),
                );

                return Container(
                  margin: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 10,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      planetCard,
                      planetThumbnail,
                    ],
                  ),
                );
              },
              itemCount: 3,
              viewportFraction: 0.95,
              scale: 0.9,
              pagination: SwiperPagination(
                alignment: Alignment.topCenter,
                margin: EdgeInsets.only(bottom: 40),
                builder: DotSwiperPaginationBuilder(
                  color: Theme.of(context).primaryColorDark,
                ),
              ),
              // itemWidth: MediaQuery.of(context).size.width,
              // layout: SwiperLayout.STACK,
              // ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            flex: 3,
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: [
                ...List.generate(
                  3,
                  (i) => ExpandableNotifier(
                    // <-- Provides ExpandableController to its children
                    child: Container(
                      // height: 124,
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      padding: EdgeInsets.all(15),
                      // margin: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).backgroundColor,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10.0,
                            offset: Offset(0.0, 10.0),
                          ),
                        ],
                      ),
                      child: ScrollOnExpand(
                        child: Column(
                          children: [
                            Expandable(
                              collapsed: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(
                                    Icons.alt_route,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  Text(
                                    "Маршрут #${i + 1}",
                                    style: GoogleFonts.lato(
                                      color: Colors.grey[300],
                                      fontSize: 16,
                                    ),
                                  ),
                                  ExpandableButton(
                                    child: Icon(
                                      Icons.expand_more,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              expanded: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Icon(
                                        Icons.play_circle_fill,
                                        color: Theme.of(context).primaryColor,
                                        size: 28,
                                      ),
                                      Text(
                                        "Маршрут #${i + 1}",
                                        style: GoogleFonts.lato(
                                          color: Colors.grey[300],
                                          fontSize: 16,
                                        ),
                                      ),
                                      ExpandableButton(
                                        child: Icon(
                                          Icons.expand_less,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    height: 40,
                                    padding: EdgeInsets.symmetric(vertical: 5),
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      // padding: EdgeInsets.only(right: 20),
                                      child: LocomotiveFunctions(
                                        columns: 5,
                                        rows: 1,
                                        functions: List.generate(
                                          5,
                                          (i) => LocoFunction(i, i % 2 == 0),
                                        ),
                                        childBuilder: (f) => Text('A${f + 1}'),
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
            ),
          ),
        ],
      ),
    );
  }
}
