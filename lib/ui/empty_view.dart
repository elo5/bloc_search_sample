import 'package:flutter/material.dart';
import 'package:bloc_search_sample/res/styles.dart';

class EmptyView extends StatelessWidget {
  const EmptyView(
      {Key key,
      this.error,
      this.backgroundColor,
      this.height})
      : super(key: key);
  final String error;
  final Color backgroundColor;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      color: backgroundColor ?? Colors.white,
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(Icons.error, color: Colors.red,size: 100,),
          SizedBox(
            height: 20,
          ),
          new Text(
            error,
            textAlign: TextAlign.center,
            style: TextStyles.Med_16_333,
          ),
        ],
      ),
    );
  }
}
