import 'package:flutter/material.dart';
import '../../veiw_model/helper/thems/color.dart';

/// A small teal arrow used as a subtle "tap to navigate" cue.
/// No text — the card title is self-explanatory.
class GotoWidget extends StatelessWidget {
  final VoidCallback? onpressed;
  const GotoWidget({Key? key, this.onpressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.arrow_forward_ios_rounded,
      color: primaryColor,
      size: 14,
    );
  }
}
