import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:to_do_list_app/Constant/const_text.dart';

class Util {
  /// UI related
  static BoxShadow commonBoxShadow() {
    return BoxShadow(
      color: Colors.grey.withOpacity(0.5),
      offset: Offset(0, 1),
      blurRadius: 3,
    );
  }

  static showCustomDialog(BuildContext context, String message,
      List<Widget> buttonList, String title) {
    return showDialog(
      context: context,
      builder: (context) => (Platform.isIOS)
          ? CupertinoAlertDialog(
              title: (title.isNotEmpty)
                  ? Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: ConstantText.FONT_WEIGHT_BOLD,
                        ),
                      ),
                    )
                  : SizedBox(height: 0),
              content: Text(
                message,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: ConstantText.FONT_WEIGHT_MEDIUM,
                  color: Colors.black,
                ),
              ),
              actions: buttonList,
            )
          : AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              elevation: 5.0,
              title: (title.isNotEmpty)
                  ? Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: ConstantText.FONT_WEIGHT_BOLD,
                        color: Colors.black,
                      ),
                    )
                  : SizedBox(height: 0),
              titlePadding: EdgeInsets.all(
                (title.isNotEmpty) ? 15 : 0,
              ),
              contentPadding: EdgeInsets.only(
                top: (title.isNotEmpty) ? 0 : 15,
                left: 15,
                right: 15,
                bottom: 0,
              ),
              content: Text(
                message,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: ConstantText.FONT_WEIGHT_MEDIUM,
                  color: Colors.black,
                ),
              ),
              actions: buttonList,
            ),
    );
  }

  /// Navigator related
  static Future<dynamic> pushTo(BuildContext context,
      Widget Function() createScreen, String screenName) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => createScreen(),
        settings: RouteSettings(
          name: screenName,
        ),
      ),
    );

    return result;
  }
}
