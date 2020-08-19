/**
 * Abstraction for speech operations
 */
abstract class ISpeechController {
  Future<void> initSpeechState();
  void startListening();
  void stopListening();
  void cancelListening();
}