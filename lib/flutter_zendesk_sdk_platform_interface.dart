import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_zendesk_sdk_method_channel.dart';

abstract class FlutterZendeskSdkPlatform extends PlatformInterface {
  /// Constructs a FlutterZendeskSdkPlatform.
  FlutterZendeskSdkPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterZendeskSdkPlatform _instance = MethodChannelFlutterZendeskSdk();

  /// The default instance of [FlutterZendeskSdkPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterZendeskSdk].
  static FlutterZendeskSdkPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterZendeskSdkPlatform] when
  /// they register themselves.
  static set instance(FlutterZendeskSdkPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
