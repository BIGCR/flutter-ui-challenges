import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OnOffSwitch extends StatefulWidget {
  static final routeName = '/on-off-switch';

  @override
  _OnOffSwitchState createState() => _OnOffSwitchState();
}

class _OnOffSwitchState extends State<OnOffSwitch> {
  bool isOn = false;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Container(
      child: Scaffold(
        backgroundColor: isOn ? Colors.yellow : Colors.grey[900],
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          iconTheme: isOn ? IconThemeData(color: Colors.black) : null,
        ),
        body: Center(
          child: Container(
            width: width,
            height: double.infinity,
            padding: const EdgeInsets.all(10.0),
            child: Stack(
              overflow: Overflow.visible,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Transform.translate(
                    offset: Offset(0.0, -50),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bedroom',
                          style: TextStyle(
                              fontSize: 70,
                              fontWeight: FontWeight.bold,
                              color: isOn ? Colors.black : Colors.white),
                        ),
                        Text(
                          '74\u00b0',
                          style: TextStyle(
                              fontSize: 40,
                              color: isOn ? Colors.black : Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Transform.translate(
                    offset: Offset(0.0, 50.0),
                    child: LightSwitch(
                      onTap: (on) {
                        setState(
                          () {
                            isOn = on;
                          },
                        );
                      },
                    ),
                  ),
                ),
                AnimatedPositioned(
                  duration: Duration(milliseconds: 50),
                  right: 25,
                  top: 0 - kToolbarHeight - MediaQuery.of(context).padding.top,
                  bottom: isOn ? height * .45 : height * .30,
                  width: 2,
                  // height: height,
                  child: Container(
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LightSwitch extends StatefulWidget {
  final Function(bool) onTap;

  const LightSwitch({Key key, this.onTap}) : super(key: key);

  @override
  _LightSwitchState createState() => _LightSwitchState();
}

class _LightSwitchState extends State<LightSwitch>
    with SingleTickerProviderStateMixin {
  bool isOn = false;
  AnimationController _controller;
  Duration duration = Duration(milliseconds: 50);

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: duration,
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleSwitch() {
    var tempOn = !isOn;
    setState(() {
      isOn = tempOn;
    });

    if (widget.onTap != null) {
      widget.onTap(tempOn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragEnd: (_) {
        _toggleSwitch();
      },
      onTap: _toggleSwitch,
      child: Container(
        width: 50,
        height: 150,
        child: Stack(
          overflow: Overflow.visible,
          alignment: isOn ? Alignment.topCenter : Alignment.bottomCenter,
          children: [
            Container(
              height: 150,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadiusDirectional.all(Radius.circular(30.0)),
                color:
                    isOn ? Colors.grey[800].withOpacity(.2) : Colors.grey[800],
              ),
            ),
            AnimatedAlign(
              alignment: isOn ? Alignment.topCenter : Alignment.bottomCenter,
              duration: duration,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
