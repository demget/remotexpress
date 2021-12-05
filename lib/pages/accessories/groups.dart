import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remotexpress/l10n.dart';
import 'package:remotexpress/pages/accessories/buttons.dart';

class AccessoryGroups extends StatefulWidget {
  AccessoryGroups();

  @override
  _AccessoryGroupsState createState() => _AccessoryGroupsState();
}

class _AccessoryGroupsState extends State<AccessoryGroups> {
  Widget buildItem(BuildContext context, int i) {
    final title = [
      L10n.of(context)!.accessoryGroupTurnouts,
      L10n.of(context)!.accessoryGroupLight,
      L10n.of(context)!.accessoryGroupSound,
    ][i];
    final icon = [
      Icons.compare_arrows,
      Icons.lightbulb,
      Icons.volume_up,
    ][i];

    return Container(
      margin: EdgeInsets.all(10),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 124,
            padding: EdgeInsets.only(left: 35, right: 25),
            margin: EdgeInsets.only(left: 30),
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
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 16),
              constraints: BoxConstraints.expand(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 4),
                  Padding(
                    padding: EdgeInsets.only(left: 40),
                    child: Text(
                      title,
                      style: GoogleFonts.lato(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Container(height: 10),
                  Container(
                    height: 40,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: AccessoryButtons(),
                      // LocomotiveFunctions(
                      //   columns: 6,
                      //   rows: 1,
                      //   // offset: index + 1,
                      //   functions: List.generate(
                      //     12,
                      //     (i) => LocoFunction(i),
                      //   ),
                      //   onToggle: (_) {},
                      //   childBuilder: (f) => Text('A${f + 1}'),
                      // ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 16),
            alignment: FractionalOffset.centerLeft,
            child: CircleAvatar(
              radius: 40,
              backgroundColor: Theme.of(context).primaryColor,
              child: IconButton(
                icon: Icon(icon),
                iconSize: 40,
                color: Colors.white,
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Swiper(
      itemCount: 3,
      scale: 0.9,
      viewportFraction: 0.95,
      itemBuilder: buildItem,
      pagination: SwiperPagination(
        alignment: Alignment.topCenter,
        margin: EdgeInsets.only(bottom: 40),
        builder: DotSwiperPaginationBuilder(
          color: Theme.of(context).primaryColorDark,
        ),
      ),
    );
  }
}
