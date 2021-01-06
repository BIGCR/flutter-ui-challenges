import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../url_util.dart';

enum Direction { left, right, up, down }

class CornerCross extends StatefulWidget {
  static final routeName = '/corner-cross';

  @override
  _CornerCrossState createState() => _CornerCrossState();
}

class _CornerCrossState extends State<CornerCross>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  bool isClockwise = true;

  @override
  void initState() {
    _controller = AnimationController(
      duration: Duration(milliseconds: 500, seconds: 3),
      vsync: this,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed ||
            status == AnimationStatus.dismissed) {
          if (isClockwise) {
            _controller.repeat();
          } else {
            _controller.reverse(from: 1);
          }
        }
      });

    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleController() {
    if (_controller.status == AnimationStatus.forward) {
      isClockwise = false;
      _controller.reverse();
    } else {
      isClockwise = true;
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Game'),
        actions: [
          IconButton(icon: FaIcon(FontAwesomeIcons.pinterest), onPressed: () {
            UrlUtil.launchURL('https://www.pinterest.com/pin/764837949211222549/');
          })
        ],
      ),
      body: InkWell(
        onTap: _toggleController,
        enableFeedback: false,
        child: Stack(
          alignment: Alignment.centerRight,
          children: [
            Container(),
            Align(
              alignment: Alignment.center,
              child: Container(
                width: width * .55,
                height: width * .55,
                child: Stack(
                  overflow: Overflow.visible,
                  fit: StackFit.expand,
                  children: [
                    Positioned(
                      left: -17,
                      top: -17,
                      child: Transform(
                        alignment: Alignment.centerRight,
                        transform: Matrix4.identity()..rotateZ(pi / 4),
                        child: TargetBarrier(),
                      ),
                    ),
                    Positioned(
                      right: -17,
                      top: -17,
                      child: Transform(
                        alignment: Alignment.centerLeft,
                        transform: Matrix4.identity()..rotateZ(-pi / 4),
                        child: TargetBarrier(),
                      ),
                    ),
                    Positioned(
                      right: -17,
                      bottom: -17,
                      child: Transform(
                        alignment: Alignment.centerLeft,
                        transform: Matrix4.identity()..rotateZ(pi / 4),
                        child: TargetBarrier(),
                      ),
                    ),
                    Positioned(
                      left: -17,
                      bottom: -17,
                      child: Transform(
                        alignment: Alignment.centerRight,
                        transform: Matrix4.identity()..rotateZ(-pi / 4),
                        child: TargetBarrier(),
                      ),
                    ),
                    PlayerParticle(
                      controller: _controller,
                    )
                  ],
                ),
              ),
            ),
            DangerParticle(
              offset: Offset(20.0, -50.0),
            ),
            DangerParticle(),
            DangerParticle(
              offset: Offset(20.0, 50.0),
            ),
          ],
        ),
      ),
    );
  }
}

class PlayerParticle extends AnimatedWidget {
  PlayerParticle({Key key, AnimationController controller})
      : super(key: key, listenable: controller);

  final Widget _child = Container(
    height: 20,
    width: 20,
    decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.green),
  );

  final List<TweenSequenceItem<AlignmentGeometry>> sequenceItems = [
    TweenSequenceItem<AlignmentGeometry>(
      tween: AlignmentTween(
        begin: Alignment.topLeft,
        end: Alignment.topRight,
      ),
      weight: 1 / 4,
    ),
    TweenSequenceItem<AlignmentGeometry>(
      tween: AlignmentTween(
        begin: Alignment.topRight,
        end: Alignment.bottomRight,
      ),
      weight: 1 / 4,
    ),
    TweenSequenceItem<AlignmentGeometry>(
      tween: AlignmentTween(
        begin: Alignment.bottomRight,
        end: Alignment.bottomLeft,
      ),
      weight: 1 / 4,
    ),
    TweenSequenceItem<AlignmentGeometry>(
      tween: AlignmentTween(
        begin: Alignment.bottomLeft,
        end: Alignment.topLeft,
      ),
      weight: 1 / 4,
    ),
  ];

  Animation<AlignmentGeometry> get animation =>
      TweenSequence<AlignmentGeometry>(sequenceItems).animate(listenable);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      child: Container(
        height: 20,
        width: 20,
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.green),
      ),
      builder: (context, Widget child) {
        // print('Position ${this}');
        return AlignTransition(
          alignment: animation,
          child: child,
        );
      },
    );
  }
}

class TargetBarrier extends StatefulWidget {
  @override
  _TargetBarrierState createState() => _TargetBarrierState();
}

class _TargetBarrierState extends State<TargetBarrier> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 20,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
          color: Colors.grey),
    );
  }
}

class DangerParticle extends StatefulWidget {
  final Offset offset;

  const DangerParticle({
    Key key,
    this.offset = const Offset(20.0, 0.0),
  }) : super(key: key);

  @override
  _DangerParticleState createState() => _DangerParticleState();
}

class _DangerParticleState extends State<DangerParticle>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  var random = Random();

  @override
  void initState() {
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reset();
          Future.delayed(Duration(milliseconds: 100 * random.nextInt(25)), () {
            if (this.mounted) {
              _controller.forward();
            }
          });
        }
      });

    Future.delayed(Duration(milliseconds: 100 * random.nextInt(25)), () {
      if (this.mounted) {
        _controller.forward();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return AnimatedBuilder(
      animation: _controller,
      child: Container(
        width: 20,
        height: 20,
        decoration:
            BoxDecoration(shape: BoxShape.rectangle, color: Colors.black),
      ),
      builder: (context, child) {
        return Transform.translate(
          offset: widget.offset,
          child: Transform(
            transform: Matrix4.identity()
              ..translate(1 - width * _controller.value),
            child: child,
          ),
        );
      },
    );
  }
}
