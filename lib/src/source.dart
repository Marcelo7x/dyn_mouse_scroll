import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'scroll_state.dart';

class DynMouseScroll extends StatelessWidget {
  final ScrollPhysics mobilePhysics;
  final int durationMS;
  final double scrollSpeed;
  final Curve animationCurve;
  final Function(BuildContext, ScrollController, ScrollPhysics) builder;
  final ScrollController? controller;

  const DynMouseScroll({
    super.key,
    this.mobilePhysics = kMobilePhysics,
    this.durationMS = 380,
    this.scrollSpeed = 2,
    this.animationCurve = Curves.easeOutQuart,
    required this.builder,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ScrollState>(
      create: (context) => ScrollState(mobilePhysics, durationMS, controller: controller),
      builder: (context, _) {
        final scrollState = context.read<ScrollState>();
        final controller = scrollState.controller;
        final physics = context.select((ScrollState s) => s.physics);
        scrollState.handlePipelinedScroll?.call();
        return Listener(
          onPointerSignal: (signalEvent) => scrollState.handleDesktopScroll(
            signalEvent, scrollSpeed, animationCurve),
          onPointerDown: scrollState.handleTouchScroll,
          child: builder(context, controller, physics),
        );
      },
    );
  }
}