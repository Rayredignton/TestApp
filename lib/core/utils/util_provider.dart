import 'package:flutter/material.dart';

class UtilProvider {
  static void showAppBottomSheet({required BuildContext context, required Widget Function(BuildContext) builder, bool? isScrollControlled, Function? onThen,}) {
    showModalBottomSheet(context: context, enableDrag: false, isDismissible: true, builder: builder, backgroundColor: Colors.transparent, isScrollControlled: isScrollControlled ?? false)
        .then((value) {
      if (onThen != null) {
        onThen();
      }
    });
  }
}