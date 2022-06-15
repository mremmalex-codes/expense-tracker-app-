import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptiveTextButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const AdaptiveTextButton(
      {Key? key, required this.text, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoButton(
            onPressed: onPressed,
            child: Text(text),
          )
        : TextButton(
            onPressed: onPressed,
            style: TextButton.styleFrom(
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
                primary: Theme.of(context).primaryColor),
            child: Text(text),
          );
  }
}
