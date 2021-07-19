import 'package:flutter/cupertino.dart';

class NoAnimationPage extends Page {
  final Widget child;
  NoAnimationPage({Key key, this.child}) : super(key: key);

  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
        settings: this,
        pageBuilder: (context, animation, animation2) {
          return child;
        },
        transitionDuration: Duration(milliseconds: 1));
  }
}
