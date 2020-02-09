# Selectable Autolink Text

[![pub package](https://img.shields.io/pub/v/selectable_autolink_text.svg)](https://pub.dartlang.org/packages/selectable_autolink_text)

Generate inline links that can be selected and tapped in text for Flutter

![Example](https://github.com/miyakeryo/flutter_selectable_autolink_text/raw/master/example/screen.gif)

## Install

https://pub.dev/packages/selectable_autolink_text#-installing-tab-

## Usage

### Basic

```dart
import 'package:selectable_autolink_text/selectable_autolink_text.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SelectableAutoLinkText(
      'Basic https://flutter.dev',
      linkStyle: TextStyle(color: Colors.blueAccent),
      highlightedLinkStyle: TextStyle(
        color: Colors.blueAccent,
        backgroundColor: Color(0x33448AFF),
      ),
      onTap: (url) => launch(url, forceSafariVC: false),
      onLongPress: (url) => Share.share(url),
    );
  }
}
```

### Advanced

```dart
import 'package:selectable_autolink_text/selectable_autolink_text.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SelectableAutoLinkText(
      '''
Advanced
You can shrink url like https://github.com/miyakeryo/flutter_selectable_autolink_text
tel: 012-3456-7890
email: mail@example.com''',
      style: TextStyle(color: Colors.green[800]),
      linkStyle: TextStyle(color: Colors.purpleAccent),
      highlightedLinkStyle: TextStyle(
        color: Colors.purpleAccent,
        backgroundColor: Color(0x33E040FB),
      ),
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
    );
  }
}
```

### Customized

```dart
import 'package:selectable_autolink_text/selectable_autolink_text.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SelectableAutoLinkText(
      'Custom links'
      '\nHi! @screen_name.'
      ' If you customize the regular expression, you can make them.'
      ' #hash_tag',
      linkStyle: TextStyle(color: Colors.orangeAccent),
      highlightedLinkStyle: TextStyle(
        color: Colors.orangeAccent[700],
        backgroundColor: Color(0x33FF6D00),
      ),
      linkRegExpPattern: '(@[\\w]+|#[\\w]+|${AutoLinkUtils.urlRegExpPattern})',
      onTransformDisplayLink: AutoLinkUtils.shrinkUrl,
      onTap: (url) => print('🍒Tap: $url'),
      onLongPress: (url) => print('🍩LongPress: $url'),
    );
  }
}
```

### More advanced usage

```dart
import 'package:selectable_autolink_text/selectable_autolink_text.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
}
```