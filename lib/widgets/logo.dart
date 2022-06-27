import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Logo extends StatelessWidget {
  static Widget animated(void Function() onCompleted) {
    return _AnimatedLogo(onCompleted: onCompleted);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            Icons.train,
            size: 80,
            color: Theme.of(context).primaryColorDark,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 20.0),
        ),
        Text(
          "Xpress",
          style: TextStyle(
            color: Colors.grey[200],
            fontWeight: FontWeight.bold,
            fontSize: 60,
          ),
        ),
      ],
    );
  }
}

class _AnimatedLogo extends StatefulWidget {
  void Function() onCompleted;

  _AnimatedLogo({required this.onCompleted});

  @override
  __AnimatedLogoState createState() => __AnimatedLogoState();
}

class __AnimatedLogoState extends State<_AnimatedLogo>
    with TickerProviderStateMixin {
  late AnimationController iconAnimation;

  @override
  void initState() {
    iconAnimation = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
      lowerBound: 10,
      upperBound: 80,
    )..forward();

    iconAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onCompleted();
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    iconAnimation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: iconAnimation,
      builder: (context, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.train,
                size: iconAnimation.value,
                color: Theme.of(context).primaryColorDark,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
            ),
            Text(
              "Xpress",
              style: TextStyle(
                color: Colors.grey[200],
                fontWeight: FontWeight.bold,
                fontSize: iconAnimation.value - 20,
              ),
            ),
          ],
        );
      },
    );
  }
}
