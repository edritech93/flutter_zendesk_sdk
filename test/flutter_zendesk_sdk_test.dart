import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_zendesk_sdk/flutter_zendesk_sdk.dart';
import 'package:flutter_zendesk_sdk/flutter_zendesk_sdk_platform_interface.dart';
import 'package:flutter_zendesk_sdk/flutter_zendesk_sdk_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterZendeskSdkPlatform
    with MockPlatformInterfaceMixin
    implements FlutterZendeskSdkPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterZendeskSdkPlatform initialPlatform = FlutterZendeskSdkPlatform.instance;

  test('$MethodChannelFlutterZendeskSdk is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterZendeskSdk>());
  });

  test('getPlatformVersion', () async {
    FlutterZendeskSdk flutterZendeskSdkPlugin = FlutterZendeskSdk();
    MockFlutterZendeskSdkPlatform fakePlatform = MockFlutterZendeskSdkPlatform();
    FlutterZendeskSdkPlatform.instance = fakePlatform;

    expect(await flutterZendeskSdkPlugin.getPlatformVersion(), '42');
  });
}
