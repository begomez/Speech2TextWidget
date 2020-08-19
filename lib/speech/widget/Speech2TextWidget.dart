import 'dart:async';

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speechapp/speech/controller/ISpeechController.dart';
import 'package:speechapp/speech/controller/SpeechControllerImpl.dart';


/**
 * Widget containing an interactive icon hooked to a speech controller
 */
class Speech2TextWidget extends StatefulWidget {
  final Function(String) resultCallback;
 
  const Speech2TextWidget({@required this.resultCallback, Key key}) : super(key: key);
  
  @override
  State<StatefulWidget> createState() => _Speech2TextWidgetState();
}

class _Speech2TextWidgetState extends State<Speech2TextWidget> {
  ISpeechController _controller;

  
  _Speech2TextWidgetState() : super();


  @override
  void initState() {
    super.initState();

    this._initController();
  }

  Future<void> _initController() async {
    this._controller = SpeechControllerImpl(stateCallback: () {
      this.setState(() {});
    }, resultCallback: (str) {
      this.widget.resultCallback?.call(str);
    });

    await this._controller.initSpeechState();

    return;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Icon(Icons.mic),
        onLongPress: () {
          this._controller.startListening();
        },
        onLongPressEnd: (details) {
          this._controller.stopListening();
        },
    );
  }
}