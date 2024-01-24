library  styles;


import 'package:flutter/material.dart';
import 'package:tazawad/utils/my_color.dart';
import 'package:tazawad/utils/text_styles.dart';

class CAText extends StatefulWidget {
 CAText(
   String data, {
   super.key,
   this.style,
   this.color,
   this.maxLines,
  
 })  : data = '',
       assert(maxLines == null || maxLines > 0);
 final CATextStyle? style;
 final CAColor? color;
 final int? maxLines;
 final String? data;
 
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CATextState();
  }

}
class _CATextState  extends State<CAText>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

}