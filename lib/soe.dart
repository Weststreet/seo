import 'dart:async';

import 'package:flutter/services.dart';

import 'dart:async';
import 'package:flutter/services.dart';

const EventChannel _gyroscopeEventChannel =
EventChannel('plugins.flutter.io/sensors/gyroscope');

const MethodChannel _channel = const MethodChannel('youban_ifly');

Stream<String> _gyroscopeEvents;

/// A broadcast stream of events from the device gyroscope.
Stream<String> get gyroscopeEvents {
  if (_gyroscopeEvents == null) {
    _gyroscopeEvents = _gyroscopeEventChannel
        .receiveBroadcastStream()
        .map((dynamic event) => event.toString());
  }
  return _gyroscopeEvents;
}

Future<String> get platformVersion async {
  final String version = await _channel.invokeMethod('getPlatformVersion');
  return version;
}

startListening(String sentence,String appId,String secretId,String secretKey) async {
  final Map<String, dynamic> params = {};
  params['sentence'] = sentence;
  params['appId'] = appId;
  params['secretId'] = secretId;
  params['secretKey'] = secretKey;
  await _channel.invokeMethod('startRecord', params);
}

stopListening() async {
  await _channel.invokeMethod('stopRecord');
}

