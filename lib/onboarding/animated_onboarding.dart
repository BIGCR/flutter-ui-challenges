import 'package:flutter/material.dart';

class Onboarding extends StatefulWidget {
  static final String routeName = '/onboarding';

  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  PageController _pageController;

  ValueNotifier<int> _position = ValueNotifier(0);

  BoxDecoration _getBackgroundGradient() {
    Color startColor;
    Color endColor;

    switch (_position.value) {
      case 0:
        {
          startColor = Colors.teal[100];
          endColor = Colors.teal[300];
          break;
        }
      case 1:
        {
          startColor = Colors.deepPurpleAccent[100];
          endColor = Colors.deepPurpleAccent[200];
          break;
        }
      default:
        {
          startColor = Colors.pinkAccent[100];
          endColor = Colors.pinkAccent[200];
        }
    }

    return BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [startColor, endColor]));
  }

  @override
  void initState() {
    _pageController = PageController(
      keepPage: false,
    );
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _getBackgroundGradient(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              _position.value = index;
              setState(() {});
            },
            children: <Widget>[
              Page(
                position: 0,
              ),
              Page(
                position: 1,
              ),
              Page(
                position: 2,
              ),
            ],
          ),
          Positioned(
            bottom: 25,
            left: 50,
            right: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 50,
                  child: PageIndicators(
                    position: _position,
                  ),
                ),
                FloatingActionButton(
                  child: Icon(
                    Icons.chevron_right,
                    color: Colors.black,
                  ),
                  backgroundColor: Colors.yellow,
                  onPressed: () {
                    if (_position.value < 2) {
                      _pageController.animateToPage(_position.value + 1,
                          duration: Duration(milliseconds: 200),
                          curve: Curves.linearToEaseOut);
                      setState(() {});
                    }
                  },
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

class Page extends StatefulWidget {
  final int position;

  const Page({Key key, this.position}) : super(key: key);

  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<Page> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 250));

    Future.delayed(Duration(milliseconds: 200), () {
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.scale(
                  scale: _controller.value,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: 250,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white12,
                        ),
                      ),
                      Container(
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white24,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: SlideUpEntrance(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      'Discover & Share',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline2.copyWith(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  Text(
                    'I wish I had a lot of money so I could buy all the things!! I wish I had a lot of money so I could buy all the things!! I wish I had a lot of money so I could buy all the things!!',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PageIndicators extends StatefulWidget {
  final ValueNotifier<int> position;

  const PageIndicators({Key key, this.position}) : super(key: key);

  @override
  _PageIndicatorState createState() => _PageIndicatorState();
}

class _PageIndicatorState extends State<PageIndicators> {
  Widget _buildIndicator() {
    return Container(
      decoration:
          BoxDecoration(shape: BoxShape.circle, color: Colors.grey[400]),
      width: 10,
      height: 10,
    );
  }

  Widget _buildActiveIndicator() {
    Alignment align = Alignment.centerLeft;
    if (widget.position.value == 1) {
      align = Alignment.center;
    } else if (widget.position.value == 2) {
      align = Alignment.centerRight;
    }

    return AnimatedAlign(
      alignment: align,
      duration: Duration(milliseconds: 200),
      child: Container(
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
        width: 10,
        height: 10,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: _buildIndicator(),
        ),
        Align(
          alignment: Alignment.center,
          child: _buildIndicator(),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: _buildIndicator(),
        ),
        _buildActiveIndicator(),
      ],
    );
  }
}

class SlideUpEntrance extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;
  final Offset offset;

  const SlideUpEntrance(
      {Key key,
      this.duration = const Duration(milliseconds: 250),
      this.delay = const Duration(milliseconds: 300),
      this.offset = const Offset(0.0, 50.0),
      this.child})
      : super(key: key);

  @override
  _SlideUpEntranceState createState() => _SlideUpEntranceState();
}

class _SlideUpEntranceState extends State<SlideUpEntrance>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _dyAnimation;

  @override
  void initState() {
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _dyAnimation =
        Tween(begin: widget.offset.dy, end: 0.0).animate(_controller);

    Future.delayed(widget.delay, () {
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
    return Align(
      alignment: Alignment.center,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => Opacity(
          opacity: _controller.value,
          child: Transform.translate(
            offset: Offset(0.0, _dyAnimation.value),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
