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
      debugShowCheckedModeBanner: false,
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
            _basic(context),
            const Divider(height: 32),
            _advanced(context),
            const Divider(height: 32),
            _custom(context),
            const Divider(height: 32),
            _moreAdvanced(context),
          ],
        ),
      ),
    );
  }

  Widget _basic(BuildContext context) {
    return SelectableAutoLinkText(
      'Basic\n'
      'Generate inline links that can be selected, tapped, '
      'long pressed and highlighted on tap.\n'
      'As written below.\n'
      'Dart packages https://pub.dev',
      linkStyle: const TextStyle(color: Colors.blueAccent),
      highlightedLinkStyle: const TextStyle(
        color: Colors.blueAccent,
        backgroundColor: Color(0x33448AFF),
      ),
      onTap: (url) => launch(url, forceSafariVC: false),
      onLongPress: (url) => Share.share(url),
    );
  }

  Widget _advanced(BuildContext context) {
    return SelectableAutoLinkText(
      '''
Advanced
You can shrink url like https://github.com/miyakeryo/flutter_selectable_autolink_text
tel: 012-3456-7890
email: mail@example.com''',
      style: const TextStyle(color: Color(0xFF2E7D32)),
      linkStyle: const TextStyle(color: Colors.purpleAccent),
      highlightedLinkStyle: const TextStyle(
        color: Colors.purpleAccent,
        backgroundColor: Color(0x33E040FB),
      ),
      onTransformDisplayLink: AutoLinkUtils.shrinkUrl,
      onTap: (url) async {
        print('🌶Tap: $url');
        if (await canLaunch(url)) {
          launch(url, forceSafariVC: false);
        } else {
          _alert(context, '🌶Tap', url);
        }
      },
      onLongPress: (url) {
        print('🍔LongPress: $url');
        Share.share(url);
      },
      onTapOther: () {
        print('🍇️onTapOther');
      },
    );
  }

  Widget _custom(BuildContext context) {
    return SelectableAutoLinkText(
      'Custom links'
      '\nHi! @screen_name.'
      ' If you customize the regular expression, you can make them.'
      ' #hash_tag',
      style: const TextStyle(color: Colors.black87),
      linkStyle: const TextStyle(color: Color(0xFFFF6D00)),
      highlightedLinkStyle: const TextStyle(
        color: Color(0xFFFF6D00),
        backgroundColor: Color(0x33FF6D00),
      ),
      linkRegExpPattern: '(@[\\w]+|#[\\w]+|${AutoLinkUtils.urlRegExpPattern})',
      onTransformDisplayLink: AutoLinkUtils.shrinkUrl,
      onTap: (url) => _alert(context, '🍒Tap', url),
      onLongPress: (url) => _alert(context, '🍩LongPress', url),
      onDebugMatch: (match) =>
          print('DebugMatch:[${match.start}-${match.end}]`${match.group(0)}`'),
    );
  }

  Widget _moreAdvanced(BuildContext context) {
    final blueStyle = const TextStyle(color: Colors.blueAccent);
    final highlightedStyle = const TextStyle(
        color: Colors.blueAccent, backgroundColor: Color(0x33448AFF));
    final pinkStyle = const TextStyle(color: Colors.pink);
    final boldStyle =
        const TextStyle(fontWeight: FontWeight.bold, fontSize: 14);
    final italic2Style =
        const TextStyle(fontStyle: FontStyle.italic, fontSize: 14);
    final bigStyle = const TextStyle(fontSize: 18);
    final regExpPattern = r'\[([^\]]+)\]\(([\S]+)\)';
    final regExp = RegExp(regExpPattern);

    return SelectableAutoLinkText(
      '''
More advanced usage

[This is a link text](https://google.com)
[This text is bold](bold)
This text is normal
[This text is italic](italic2)
[This text is pink](pink)
[This text is big](big)''',
      linkRegExpPattern: regExpPattern,
      onTransformDisplayLink: (s) {
        final match = regExp.firstMatch(s);
        if (match?.groupCount == 2) {
          final text1 = match.group(1);
          final text2 = match.group(2);
          switch (text2) {
            case 'bold':
              return LinkAttribute(text1, link: null, style: boldStyle);
            case 'italic2':
              return LinkAttribute(text1, link: null, style: italic2Style);
            case 'pink':
              return LinkAttribute(text1, link: null, style: pinkStyle);
            case 'big':
              return LinkAttribute(text1, link: null, style: bigStyle);
            default:
              if (text2.startsWith('http')) {
                return LinkAttribute(
                  text1,
                  link: text2,
                  style: blueStyle,
                  highlightedStyle: highlightedStyle,
                );
              } else {
                return LinkAttribute(text1, link: null);
              }
          }
        }
        return LinkAttribute(s, link: null);
      },
      onTap: (url) => launch(url, forceSafariVC: false),
      onLongPress: (url) => Share.share(url),
    );
  }

  Future _alert(BuildContext context, String title, [String message]) async {
    return await showDialog(
      context: context,
      builder: (c) {
        return AlertDialog(
          title: Text(title),
          content: message != null ? Text(message) : null,
          actions: [
            FlatButton(
              color: Colors.lightBlueAccent,
              textColor: Colors.white,
              child: const Text('Close'),
              onPressed: () => Navigator.pop(c),
            ),
          ],
        );
      },
    );
  }
}
