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
      highlightedLinkStyle: TextStyle(
        color: Colors.blueAccent,
        backgroundColor: Colors.blueAccent.withAlpha(0x33),
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
      style: TextStyle(color: Colors.green[800]),
      linkStyle: const TextStyle(color: Colors.purpleAccent),
      highlightedLinkStyle: TextStyle(
        color: Colors.purpleAccent,
        backgroundColor: Colors.purpleAccent.withAlpha(0x33),
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
      onTapOther: (point) {
        print('🍇️onTapOther: $point');
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
      linkStyle: const TextStyle(color: Colors.deepOrangeAccent),
      highlightedLinkStyle: TextStyle(
        color: Colors.deepOrangeAccent,
        backgroundColor: Colors.deepOrangeAccent.withAlpha(0x33),
      ),
      linkRegExpPattern: '(@[\\w]+|#[\\w]+|${AutoLinkUtils.urlRegExpPattern})',
      onTransformDisplayLink: AutoLinkUtils.shrinkUrl,
      onTap: (url) => _alert(context, '🍒Tap', url),
      onLongPress: (url) => _alert(context, '🍩LongPress', url),
      onDebugMatch: (match) {
        // for debug
        print('DebugMatch:[${match.start}-${match.end}]`${match.group(0)}`');
      },
    );
  }

  Widget _moreAdvanced(BuildContext context) {
    final blueStyle = const TextStyle(color: Colors.blueAccent);
    final highlightedStyle = TextStyle(
      color: Colors.blueAccent,
      backgroundColor: Colors.blueAccent.withAlpha(0x33),
    );
    final pinkStyle = const TextStyle(color: Colors.pink);
    final boldStyle = const TextStyle(fontWeight: FontWeight.bold);
    final italicStyle = const TextStyle(fontStyle: FontStyle.italic);
    final bigStyle = const TextStyle(fontSize: 20);
    final regExpPattern = r'\[([^\]]+)\]\(([^\s\)]+)\)';
    final regExp = RegExp(regExpPattern);

    return SelectableAutoLinkText(
      '''
More advanced usage

[This is a link text](https://google.com)
[This text is bold](bold)
This text is normal
[This text is italic](italic)
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
              return LinkAttribute(text1, style: boldStyle);
            case 'italic':
              return LinkAttribute(text1, style: italicStyle);
            case 'pink':
              return LinkAttribute(text1, style: pinkStyle);
            case 'big':
              return LinkAttribute(text1, style: bigStyle);
            default:
              if (text2.startsWith('http')) {
                return LinkAttribute(
                  text1,
                  link: text2,
                  style: blueStyle,
                  highlightedStyle: highlightedStyle,
                );
              } else {
                return LinkAttribute(text1);
              }
          }
        }
        return LinkAttribute(s);
      },
      onTap: (url) => launch(url, forceSafariVC: false),
      onLongPress: (url) => Share.share(url),
    );
  }

  Future _alert(BuildContext context, String title, [String message]) {
    return showDialog(
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
