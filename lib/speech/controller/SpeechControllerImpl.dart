import 'dart:async';

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speechapp/speech/controller/ISpeechController.dart';


const double MAX_LEVEL = 50000.0;
const double NO_LEVEL = 0.0;
const int TIME_LISTENING = 10;


/**
 * Implementation of speech operations
 */
class SpeechControllerImpl implements ISpeechController {

  double level = NO_LEVEL;
  double minSoundLevel = MAX_LEVEL;
  double maxSoundLevel = -MAX_LEVEL;
  String lastWords = "";
  String lastError = "";
  String lastStatus = "";

  String _currentLocaleId = "";
  List<LocaleName> _localeNames = [];

  final SpeechToText speech = SpeechToText();
  final Function() stateCallback;
  final Function(String) resultCallback;


  SpeechControllerImpl({@required this.stateCallback, @required this.resultCallback});


////////////////////////////////////////////////////////////////////////////////
// MAIN API
////////////////////////////////////////////////////////////////////////////////

  @override
  Future<void> initSpeechState() async {
    bool hasSpeech = await speech.initialize(onError: _onErrorListener, onStatus: _onStatusListener);

    if (hasSpeech) {
      this._localeNames = await this.speech.locales();

      var systemLocale = await this.speech.systemLocale();

      this._currentLocaleId = systemLocale.localeId;
    }

    this.stateCallback?.call();
  }

  @override
  void startListening() {
    this.lastWords = "";
    this.lastError = "";
    this.speech.listen(
        onResult: _onResultListener,
        listenFor: Duration(seconds: TIME_LISTENING),
        localeId: this._currentLocaleId,
        onSoundLevelChange: _onSoundLevelListener,
        cancelOnError: true,
        partialResults: true);
  }

  @override
  void stopListening() {
    this.speech.stop();

      this.level = NO_LEVEL;
      
      this.stateCallback?.call();
  }

  @override
  void cancelListening() {
    this.speech.cancel();

    this.level = NO_LEVEL;

    this.stateCallback?.call();
  }

////////////////////////////////////////////////////////////////////////////////
// CALLBACKS
////////////////////////////////////////////////////////////////////////////////
  
  void _onResultListener(SpeechRecognitionResult result) {
    this.lastWords = "${result.recognizedWords} - ${result.finalResult}";
    
    this.resultCallback?.call(result.recognizedWords);
  }

  void _onSoundLevelListener(double level) {
    this.minSoundLevel = min(this.minSoundLevel, level);
    this.maxSoundLevel = max(this.maxSoundLevel, level);

    this.level = level;
    
    this.stateCallback?.call();
  }

  void _onErrorListener(SpeechRecognitionError error) {
    this.lastError = "${error.errorMsg} - ${error.permanent}";
    
    this.stateCallback?.call();
    
  }

  void _onStatusListener(String status) {
    this.lastStatus = "$status";
    
    this.stateCallback?.call();
  }
}