import 'dart:io';

import 'package:flutter/material.dart';
import 'package:remotexpress/l10n.dart';

class CustomDialog extends StatefulWidget {
  final String title, positiveText, negativeText;
  final String? content;
  final Widget? child;
  final GestureTapCallback? onPositivePressed, onNegativePressed;
  final Color? circleColor;
  final Icon icon;

  CustomDialog({
    required this.title,
    required this.positiveText,
    required this.negativeText,
    this.content,
    this.child,
    this.onPositivePressed,
    this.onNegativePressed,
    this.circleColor,
    this.icon = const Icon(
      Icons.message,
      size: 35,
      color: Colors.white,
    ),
  });

  @override
  _CustomDialogState createState() => _CustomDialogState();

  static void show(
    BuildContext context, {
    required String title,
    required IconData icon,
    Widget? child,
    String? content,
    String? positiveText,
    String? negativeText,
    GestureTapCallback? onPositivePressed,
    GestureTapCallback? onNegativePressed,
  }) =>
      showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: '',
        barrierColor: Colors.black54,
        transitionDuration: Duration(milliseconds: 400),
        transitionBuilder: (context, a1, a2, _) {
          return ScaleTransition(
            scale: CurvedAnimation(
              parent: a1,
              curve: Curves.elasticOut,
              reverseCurve: Curves.easeOutCubic,
            ),
            child: CustomDialog(
              icon: Icon(icon, size: 35, color: Colors.white),
              title: title,
              content: content,
              child: child,
              positiveText: positiveText ?? L10n.of(context)!.dialogPositive,
              negativeText: negativeText ?? L10n.of(context)!.dialogNegative,
              onPositivePressed: onPositivePressed ?? () => pop(context),
              onNegativePressed: onNegativePressed ?? () => exit(0),
            ),
          );
        },
        pageBuilder: (context, a1, a2) => SizedBox(),
      );

  static void error(
    BuildContext context, {
    required String title,
    required String content,
    String? positiveText,
    String? negativeText,
    GestureTapCallback? onPositivePressed,
    GestureTapCallback? onNegativePressed,
  }) =>
      show(
        context,
        icon: Icons.error,
        title: title,
        content: content,
        positiveText: positiveText,
        negativeText: negativeText,
        onPositivePressed: onPositivePressed,
        onNegativePressed: onNegativePressed,
      );

  static void pop(BuildContext context) {
    Navigator.of(context).pop();
  }
}

class _CustomDialogState extends State<CustomDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: _buildDialogContent(context),
    );
  }

  Widget _buildButton(
    BuildContext context,
    String text,
    void Function()? onPressed,
  ) {
    return FlatButton(
      child: Text(text),
      textColor: Theme.of(context).primaryColorDark,
      onPressed: onPressed ?? () => CustomDialog.pop(context),
    );
  }

  Widget _buildDialogContent(BuildContext context) {
    final positiveButton = _buildButton(
      context,
      widget.positiveText,
      widget.onPositivePressed,
    );
    final negativeButton = _buildButton(
      context,
      widget.negativeText,
      widget.onNegativePressed,
    );

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
                widget.title,
                style: Theme.of(context).textTheme.headline5,
              ),
              SizedBox(height: 10),
              widget.content != null
                  ? Text(
                      widget.content!,
                      style: Theme.of(context).textTheme.bodyText2,
                      textAlign: TextAlign.center,
                    )
                  : widget.child!,
              SizedBox(height: 16),
              ButtonBar(
                buttonMinWidth: 100,
                alignment: MainAxisAlignment.spaceEvenly,
                children: widget.negativeText != ''
                    ? [negativeButton, positiveButton]
                    : [positiveButton],
              ),
            ],
          ),
        ),
        CircleAvatar(
          maxRadius: 40,
          child: widget.icon,
          backgroundColor: widget.circleColor,
        ),
      ],
    );
  }
}
