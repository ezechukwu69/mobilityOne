import 'package:beamer/beamer.dart';
import 'package:flutter/widgets.dart';
import 'package:mobility_one/ui/screens/screen_holder.dart';

class MyBeamPage extends BeamPage {
  MyBeamPage({required Widget child, required String title, bool showHeaderNavbarAndSidebar = true})
      : super(
          child: showHeaderNavbarAndSidebar ? ScreenHolder(child: child) : child,
          title: title,
          type: BeamPageType.noTransition,
          key: ValueKey(title),
        );
}
