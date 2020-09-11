import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';

class Barrier with ChangeNotifier {
  bool isActive = false;
  Alignment alignment;
  final double zRotation;

  void toggleActive() {
    isActive = !isActive;
  }

  Barrier({Key key, this.alignment, this.zRotation});
}

class BarriersModel with ChangeNotifier {
  final Map<int, Barrier> _barriersMap = List.generate(4, (int index)  {
    return Barrier();
  }).asMap();

  UnmodifiableMapView<int, Barrier> get barriers => UnmodifiableMapView(_barriersMap);
}

class DangerParticle with ChangeNotifier {
  final Offset offset;
  final Random random = Random();
  final Color color;

  DangerParticle({Key key, this.offset, this.color = Colors.black});
}

class DangerParticlesModel with ChangeNotifier {
  final List<DangerParticle> _dangerParticles = [
    DangerParticle(),
    DangerParticle(),
    DangerParticle(),
  ];

  UnmodifiableListView<DangerParticle> get particles => UnmodifiableListView(_dangerParticles);
}