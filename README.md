# Selectable Autolink Text
Generate inline links that can be selected, clicked and long pressed in text for Flutter

![Example](https://github.com/housmart/flutter_selectable_autolink_text/raw/master/example/screen.gif)

## Install

Install by adding this package to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_selectable_autolink_text: ^1.0.0+1
```

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
      onTap: (url) => print('🍅Tap: $url'),
      onLongPress: (url) => print('🍕LongPress: $url'),
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
      'Custom link @screen_name. Hello #hash_tag! Like https://twitter.com.',
      style: TextStyle(color: Colors.brown),
      linkStyle: TextStyle(color: Colors.orangeAccent),
      linkRegExpPattern: '(@[\\w]+|#[\\w]+|${AutoLinkUtils.urlRegExpPattern})',
      onTransformDisplayLink: AutoLinkUtils.shrinkUrl,
      onTap: (url) => print('🍒Tap: $url'),
      onLongPress: (url) => print('🍩LongPress: $url'),
      onDebugMatch: (match) =>
          print('DebugMatch:[${match.start}-${match.end}]`${match.group(0)}`'),
    );
  }
}
```
