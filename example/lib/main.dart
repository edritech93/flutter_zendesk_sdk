import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_zendesk_sdk/flutter_zendesk_sdk.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List<String> channelMessages = [];

  bool isLogin = false;
  int unreadMessageCount = 0;

  @override
  void initState() {
    super.initState();
    // Optional, observe all incoming messages
    FlutterZendeskSdk.setMessageHandler((type, arguments) {
      setState(() {
        channelMessages.add("$type - args=$arguments");
      });
    });
  }

  @override
  void dispose() {
    FlutterZendeskSdk.invalidate();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final message = channelMessages.join("\n");

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Zendesk Messaging Example'),
        ),
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: ListView(
              children: [
                Text(message),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () => FlutterZendeskSdk.initialize(
                    androidChannelKey:
                        dotenv.get('ZENDESK_SDK_ANDROID', fallback: ''),
                    iosChannelKey: dotenv.get('ZENDESK_SDK_IOS', fallback: ''),
                  ),
                  child: const Text("Initialize"),
                ),
                if (isLogin) ...[
                  ElevatedButton(
                    onPressed: () => FlutterZendeskSdk.show(),
                    child: const Text("Show messaging"),
                  ),
                  ElevatedButton(
                    onPressed: () => _getUnreadMessageCount(),
                    child:
                        Text('Get unread message count - $unreadMessageCount'),
                  ),
                ],
                ElevatedButton(
                  onPressed: () => _setTags(),
                  child: const Text("Add tags"),
                ),
                ElevatedButton(
                  onPressed: () => _clearTags(),
                  child: const Text("Clear tags"),
                ),
                ElevatedButton(
                  onPressed: () => _login(),
                  child: const Text("Login"),
                ),
                ElevatedButton(
                  onPressed: () => _logout(),
                  child: const Text("Logout"),
                ),
                ElevatedButton(
                  onPressed: () => _checkUserLoggedIn(),
                  child: const Text("Check LoggedIn"),
                ),
                ElevatedButton(
                  onPressed: () => _setFields(),
                  child: const Text("Add Fields"),
                ),
                ElevatedButton(
                  onPressed: () => _clearFields(),
                  child: const Text("Clear Fields"),
                ),
                ElevatedButton(
                  onPressed: () => _show(),
                  child: const Text("Show"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _login() {
    // You can attach local observer when calling some methods to be notified when ready
    FlutterZendeskSdk.loginUserCallbacks(
      jwt: "my_jwt",
      onSuccess: (id, externalId) => setState(() {
        channelMessages.add("Login observer - SUCCESS: $id, $externalId");
        isLogin = true;
      }),
      onFailure: () => setState(() {
        channelMessages.add("Login observer - FAILURE!");
        isLogin = false;
      }),
    );
  }

  void _logout() {
    FlutterZendeskSdk.logoutUser();
    setState(() {
      isLogin = false;
    });
  }

  void _getUnreadMessageCount() async {
    final messageCount = await FlutterZendeskSdk.getUnreadMessageCount();
    if (mounted) {
      unreadMessageCount = messageCount;
      setState(() {});
    }
  }

  void _setTags() async {
    final tags = ['tag1', 'tag2', 'tag3'];
    await FlutterZendeskSdk.setConversationTags(tags);
  }

  void _clearTags() async {
    await FlutterZendeskSdk.clearConversationTags();
  }

  void _checkUserLoggedIn() async {
    final isLoggedIn = await FlutterZendeskSdk.isLoggedIn();
    setState(() {
      channelMessages.add('User is ${isLoggedIn ? '' : 'not'} logged in');
    });
  }

  void _setFields() async {
    Map<String, String> fieldsMap = {};

    fieldsMap["field1"] = "Value 1";
    fieldsMap["field2"] = "Value 2";

    await FlutterZendeskSdk.setConversationFields(fieldsMap);
  }

  void _clearFields() async {
    await FlutterZendeskSdk.clearConversationFields();
  }

  void _show() {
    FlutterZendeskSdk.show();
  }
}
