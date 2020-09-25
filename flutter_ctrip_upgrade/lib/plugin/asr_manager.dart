import 'package:flutter/services.dart';

class AsrManager {
  static const MethodChannel _channel = const MethodChannel('asr_plugin');

  //开始录音
  static Future<String> start({Map params}) async {
    return await _channel.invokeMethod('start', params ?? {});
  }

  static Future<String> stop() async{
      return await _channel.invokeMethod('stop');
  }

  static Future<String> cancle() async{
    return await _channel.invokeMethod('cancle');
  }

}
