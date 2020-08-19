import 'package:flutter/material.dart';
import 'package:speechapp/speech/widget/SpeechContainerWidget.dart';


/**
 * Application widget
 */
class SampleSpeechApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
        appBar: AppBar(
        title: const Text('Speech2Text widget'),),
        body: SpeechContainerWidget(),)
      );
  }
}
