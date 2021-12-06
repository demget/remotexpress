import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remotexpress/l10n.dart';
import 'package:remotexpress/models/group.dart';
import 'package:remotexpress/pages/accessories/buttons.dart';

class AccessoryGroups extends StatefulWidget {
  final List<Group> groups;
  final void Function(int)? onToggle;

  AccessoryGroups({
    required this.groups,
    required this.onToggle,
  });

  @override
  _AccessoryGroupsState createState() => _AccessoryGroupsState();
}

class _AccessoryGroupsState extends State<AccessoryGroups> {
  Widget buildItem(BuildContext context, int i) {
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
                      widget.groups[i].name,
                      style: GoogleFonts.lato(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Container(height: 10),
                  Container(
                    height: 40,
                    child: widget.groups[i].accessories.length != 0
                        ? SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.symmetric(horizontal: 30),
                            child: AccessoryButtons(
                              accessories: widget.groups[i].accessories,
                              childBuilder: (a) => Text('A$a'),
                              onToggle: widget.onToggle,
                            ),
                          )
                        : Padding(
                            padding: EdgeInsets.only(left: 40),
                            child: Text(
                              L10n.of(context)!.accessoriesEmpty,
                              style: TextStyle(
                                color: Colors.grey[300],
                                fontStyle: FontStyle.italic,
                              ),
                            ),
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
                icon: Icon(widget.groups[i].icon),
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
      itemCount: widget.groups.length,
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
