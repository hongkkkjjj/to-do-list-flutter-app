import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReusableAppBar extends StatelessWidget with PreferredSizeWidget {
  final String titleText;

  ReusableAppBar(this.titleText);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        titleText,
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      brightness: Brightness.light,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
