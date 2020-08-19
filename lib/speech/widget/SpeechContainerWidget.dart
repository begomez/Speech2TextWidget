import 'package:flutter/material.dart';
import 'package:speechapp/speech/widget/Speech2TextWidget.dart';

import 'Speech2TextWidget.dart';


/**
 * Container wrapping text and a speech widget
 */
class SpeechContainerWidget extends StatefulWidget {

  const SpeechContainerWidget({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SpeechContainerWidgetState();
}

class _SpeechContainerWidgetState extends State<SpeechContainerWidget> {
  String _textEntry = "";


  @override
  Widget build(BuildContext context) {
    return Container(
        height: 50,
        decoration: BoxDecoration(border: Border.all()),
        padding: EdgeInsets.all(8.0),
        margin: EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
                flex: 4,
                child: Align(alignment: Alignment.centerLeft,child: Text(this._textEntry))),
            Flexible(
                flex: 1,
                child: Align(alignment: Alignment.centerRight,child: Speech2TextWidget(resultCallback: (str) {
                  this.setState(() {
                    this._textEntry = str;
                  });
                },)))
          ],
        ),
    );
  }
}