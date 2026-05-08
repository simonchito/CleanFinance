import 'package:flutter/services.dart';

class AppExitService {
  const AppExitService();

  static const MethodChannel _channel = MethodChannel('app.cleanfinance/app');

  Future<void> exitApp() async {
    try {
      await _channel.invokeMethod<void>('exitApp');
    } on MissingPluginException {
      await SystemNavigator.pop();
    } on PlatformException {
      await SystemNavigator.pop();
    }
  }
}
