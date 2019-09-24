import 'package:flutter/material.dart';
import 'package:selectable_autolink_text/selectable_autolink_text.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text('Selectable Autolink Text'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            SelectableAutoLinkText(
              'Basic https://flutter.dev',
              linkStyle: TextStyle(color: Colors.blueAccent),
              onTap: (url) => print('🍅Tap: $url'),
              onLongPress: (url) => print('🍕LongPress: $url'),
            ),
            SizedBox(height: 32),
            SelectableAutoLinkText(
              '''
Selectable Autolink Text https://github.com/housmart/flutter_selectable_autolink_text
for Flutter https://flutter.dev
tel:012-3456-7890
tel +81-12-3456-7890
email mail@example.com''',
              style: TextStyle(color: Colors.black87),
              linkStyle: TextStyle(color: Colors.purpleAccent),
              onTransformDisplayLink: AutoLinkUtils.shrinkUrl,
              onTap: (url) async {
                print('🌶Tap: $url');
                if (await canLaunch(url)) {
                  launch(url, forceSafariVC: false);
                }
              },
              onLongPress: (url) {
                print('🍔LongPress: $url');
                Share.share(url);
              },
            ),
            SizedBox(height: 32),
            SelectableAutoLinkText(
              'Custom link @screen_name. Hello #hash_tag! Like https://twitter.com.',
              style: TextStyle(color: Colors.brown),
              linkStyle: TextStyle(color: Colors.orangeAccent),
              linkRegExpPattern:
                  '(@[\\w]+|#[\\w]+|${AutoLinkUtils.urlRegExpPattern})',
              onTransformDisplayLink: (url) {
                if (url.startsWith('#')) return url;
                return AutoLinkUtils.shrinkUrl(url);
              },
              onTap: (url) => print('🍒Tap: $url'),
              onLongPress: (url) => print('🍩LongPress: $url'),
              onDebugMatch: (match) => print(
                  'DebugMatch:[${match.start}-${match.end}]`${match.group(0)}`'),
            ),
          ],
        ),
      ),
    );
  }
}
