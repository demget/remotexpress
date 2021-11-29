import 'dart:io';

import 'package:flutter/material.dart';
import 'package:remotexpress/l10n.dart';

class CustomDialog extends StatelessWidget {
  final String title, content, positiveText, negativeText;
  final GestureTapCallback? onPositivePressed, onNegativePressed;
  final Color? circleColor;
  final Icon icon;

  CustomDialog({
    required this.title,
    required this.content,
    required this.positiveText,
    required this.negativeText,
    this.onPositivePressed,
    this.onNegativePressed,
    this.circleColor,
    this.icon = const Icon(
      Icons.message,
      size: 35,
      color: Colors.white,
    ),
  });

  static void show(
    BuildContext context, {
    required String title,
    required String content,
    String? positiveText,
    String? negativeText,
    GestureTapCallback? onPositivePressed,
    GestureTapCallback? onNegativePressed,
  }) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black54,
      transitionDuration: Duration(milliseconds: 400),
      transitionBuilder: (context, a1, a2, child) {
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: a1,
            curve: Curves.elasticOut,
            reverseCurve: Curves.easeOutCubic,
          ),
          child: CustomDialog(
            icon: Icon(Icons.error, size: 35, color: Colors.white),
            title: title,
            content: content,
            positiveText: positiveText ?? L10n.of(context)!.dialogPositive,
            negativeText: negativeText ?? L10n.of(context)!.dialogNegative,
            onPositivePressed: onPositivePressed,
            onNegativePressed: () => exit(0),
          ),
        );
      },
      pageBuilder: (context, a1, a2) => SizedBox(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: _buildDialogContent(context),
    );
  }

  Widget _buildDialogContent(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          margin: EdgeInsets.only(top: 30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.only(top: 60, left: 20, right: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headline5,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                content,
                style: Theme.of(context).textTheme.bodyText2,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 16,
              ),
              ButtonBar(
                buttonMinWidth: 100,
                alignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  FlatButton(
                    child: Text(negativeText),
                    textColor: Theme.of(context).primaryColorDark,
                    onPressed: onNegativePressed ?? () => _pop(context),
                  ),
                  FlatButton(
                    child: Text(positiveText),
                    textColor: Theme.of(context).primaryColorDark,
                    onPressed: onPositivePressed ?? () => _pop(context),
                  ),
                ],
              ),
            ],
          ),
        ),
        CircleAvatar(
          maxRadius: 40,
          child: icon,
          backgroundColor: circleColor,
        ),
      ],
    );
  }

  void _pop(BuildContext context) {
    Navigator.of(context).pop();
  }
}
