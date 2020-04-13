library xc_country_list_pick;

import 'src/country_list_pick.dart';
import 'package:flutter/material.dart';

class XCupertinoCountryListPick {
  static show(BuildContext context,
      {
        onChanged,
        isShowFlag,
        isDownIcon,
        isShowTitle,
        initialSelection,
        String fontFamily,
        double borderRadius,
        Color background,
        Color textColor,
        double textSize,
        int initialItem = 1
      }) async {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return CountryListPick(
            onChanged: onChanged,
            isShowFlag: isShowFlag,
            isDownIcon: isDownIcon,
            isShowTitle: isShowTitle,
            initialSelection: initialSelection,
            background: background,
            borderRadius: borderRadius,
            textColor: textColor,
            fontFamily: fontFamily,
            textSize: textSize,
            initialItem: initialItem,
          );
        });
  }
}
