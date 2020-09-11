import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

enum Direction { left, right, up, down }

class CornerCross extends StatefulWidget {
  static final routeName = '/corner-cross';

  @override
  _CornerCrossState createState() => _CornerCrossState();
}

class _CornerCrossState extends State<CornerCross>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Alignment _alignment = Alignment.topLeft;
  Direction _directions = Direction.left;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _alignment = Alignment.topRight;
        _directions = Direction.right;
      });
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Game'),
      ),
      body: InkWell(
        // onTap: _changeDirections,
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
                      alignment: _alignment,
                      direction: _directions,
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

class PlayerParticle extends StatefulWidget {
  final Alignment alignment;
  final Direction direction;

  const PlayerParticle({Key key, this.alignment, this.direction})
      : super(key: key);

  @override
  _PlayerParticleState createState() => _PlayerParticleState();
}

class _PlayerParticleState extends State<PlayerParticle>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  bool isClockwise = true;

  final Widget _child = Container(
    height: 20,
    width: 20,
    decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.green),
  );

  Animation<AlignmentGeometry> animation;

  final AlignmentTween topLeftToTopRight = AlignmentTween(
    begin: Alignment.topLeft,
    end: Alignment.topRight,
  );

  final AlignmentTween topRightToBottomRight = AlignmentTween(
    begin: Alignment.topRight,
    end: Alignment.bottomRight,
  );

  final AlignmentTween bottomRightToBottomLeft = AlignmentTween(
    begin: Alignment.bottomRight,
    end: Alignment.bottomLeft,
  );

  final AlignmentTween bottomLeftToTopLeft = AlignmentTween(
    begin: Alignment.bottomLeft,
    end: Alignment.topLeft,
  );

  @override
  void initState() {
    _controller =
        AnimationController(duration: Duration(milliseconds: 500, seconds: 3), vsync: this)
          ..addStatusListener(
            (status) {
              if (status == AnimationStatus.completed || status == AnimationStatus.dismissed) {
                if(isClockwise) {
                  _controller.repeat();
                } else {
                  _controller.reverse(from: 1);
                }
              }
            },
          );

    final sequenceItmes = <TweenSequenceItem<AlignmentGeometry>>[];

    sequenceItmes.add(
      TweenSequenceItem<AlignmentGeometry>(
        tween: topLeftToTopRight,
        weight: 1 / 4,
      ),
    );

    sequenceItmes.add(
      TweenSequenceItem<AlignmentGeometry>(
        tween: topRightToBottomRight,
        weight: 1 / 4,
      ),
    );

    sequenceItmes.add(
      TweenSequenceItem<AlignmentGeometry>(
        tween: bottomRightToBottomLeft,
        weight: 1 / 4,
      ),
    );

    sequenceItmes.add(
      TweenSequenceItem<AlignmentGeometry>(
        tween: bottomLeftToTopLeft,
        weight: 1 / 4,
      ),
    );

    animation = TweenSequence<AlignmentGeometry>(sequenceItmes).animate(_controller);
    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleController() {
    if(_controller.status == AnimationStatus.forward) {
      isClockwise = false;
      _controller.reverse();
    } else {
      isClockwise = true;
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        var width = constraints.biggest.width;

        return Stack(
          children: [
            InkWell(
              onTap: _toggleController,
              child: Container(
              ),
            ),
            AnimatedBuilder(
              animation: animation,
              builder: (context, child) {
                return Align(
                  alignment: animation.value,
                  child: _child,
                );
              },
            )
          ],
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
