import 'package:flutter/material.dart';

enum IndicatorSide { start, end }

class VerticalTabView extends StatefulWidget {
  final Key key;
  final int initialIndex;
  final double tabsWidth;
  final double indicatorWidth;
  final IndicatorSide indicatorSide;
  final List<Tab> tabs;
  final List<Widget> contents;
  final TextDirection direction;
  final Color indicatorColor;
  final bool disabledChangePageFromContentView;
  final Axis contentScrollAxis;
  final Color selectedTabBackgroundColor;
  final Color tabBackgroundColor;
  final TextStyle selectedTabTextStyle;
  final TextStyle tabTextStyle;
  final Duration changePageDuration;
  final Curve changePageCurve;
  final Color tabsShadowColor;
  final double tabsElevation;
  final Function(int tabIndex) onSelect;
  final Color backgroundColor;

  VerticalTabView(
      {this.key,
      @required this.tabs,
      @required this.contents,
      this.tabsWidth = 200,
      this.indicatorWidth = 3,
      this.indicatorSide,
      this.initialIndex = 0,
      this.direction = TextDirection.ltr,
      this.indicatorColor = Colors.green,
      this.disabledChangePageFromContentView = false,
      this.contentScrollAxis = Axis.horizontal,
      this.selectedTabBackgroundColor = const Color(0x1100ff00),
      this.tabBackgroundColor = const Color(0xfff8f8f8),
      this.selectedTabTextStyle = const TextStyle(color: Colors.black),
      this.tabTextStyle = const TextStyle(color: Colors.black38),
      this.changePageCurve = Curves.easeInOut,
      this.changePageDuration = const Duration(milliseconds: 300),
      this.tabsShadowColor = Colors.black54,
      this.tabsElevation = 2.0,
      this.onSelect,
      this.backgroundColor})
      : assert(
            tabs != null && contents != null && tabs.length == contents.length),
        super(key: key);

  @override
  _VerticalTabViewState createState() => _VerticalTabViewState();
}

class _VerticalTabViewState extends State<VerticalTabView>
    with TickerProviderStateMixin {
  int _selectedIndex;
  bool _changePageByTabView;

  AnimationController animationController;
  Animation<double> animation;
  Animation<RelativeRect> rectAnimation;

  PageController pageController = PageController();

  List<AnimationController> animationControllers = [];

  ScrollPhysics pageScrollPhysics = AlwaysScrollableScrollPhysics();

  @override
  void initState() {
    _selectedIndex = widget.initialIndex;
    for (int i = 0; i < widget.tabs.length; i++) {
      animationControllers.add(AnimationController(
          duration: const Duration(microseconds: 400), vsync: this));
    }
    _selectTab(widget.initialIndex);

    if (widget.disabledChangePageFromContentView == true) {
      pageScrollPhysics = NeverScrollableScrollPhysics();
    }
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      pageController.jumpToPage(widget.initialIndex);
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: widget.direction,
      child: Container(
        color: widget.backgroundColor ?? Theme.of(context).canvasColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Row(
                children: [
                  Material(
                    child: Container(
                      width: widget.tabsWidth,
                      child: MediaQuery.removePadding(
                        context: context,
                        removeTop: true,
                        child: ListView.builder(
                            itemCount: widget.tabs.length,
                            itemBuilder: (context, index) {
                              Tab tab = widget.tabs[index];
                              Alignment alignment = Alignment.centerLeft;
                              if (widget.direction == TextDirection.rtl) {
                                alignment = Alignment.centerRight;
                              }

                              Widget child;
                              if (tab.child != null) {
                                child = tab.child;
                              } else {
                                child = Container(
                                  padding: EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      (tab.icon != null)
                                          ? Row(
                                              children: [
                                                tab.icon,
                                                SizedBox(
                                                  width: 5,
                                                )
                                              ],
                                            )
                                          : Container(),
                                      (tab.text != null)
                                          ? Container(
                                              width: widget.tabsWidth - 50,
                                              child: Text(
                                                tab.text,
                                                softWrap: true,
                                                style: _selectedIndex == index
                                                    ? widget
                                                        .selectedTabTextStyle
                                                    : widget.tabTextStyle,
                                              ),
                                            )
                                          : Container()
                                    ],
                                  ),
                                );
                              }
                              Color itemBgColor = widget.tabBackgroundColor;
                              if (_selectedIndex == index) {
                                itemBgColor = widget.selectedTabBackgroundColor;
                              }
                              double left, right;
                              if (widget.direction == TextDirection.rtl) {
                                left =
                                    (widget.indicatorSide == IndicatorSide.end)
                                        ? 0
                                        : null;
                                right = (widget.indicatorSide ==
                                        IndicatorSide.start)
                                    ? 0
                                    : null;
                              } else {
                                left = (widget.indicatorSide ==
                                        IndicatorSide.start)
                                    ? 0
                                    : null;
                                right =
                                    (widget.indicatorSide == IndicatorSide.end)
                                        ? 0
                                        : null;
                              }
                              return Stack(
                                children: [
                                  Positioned(
                                    top: 2,
                                    bottom: 2,
                                    width: widget.indicatorWidth,
                                    left: left,
                                    right: right,
                                    child: ScaleTransition(
                                      child: Container(
                                        color: widget.indicatorColor,
                                      ),
                                      scale: Tween(begin: 0.0, end: 0.0)
                                          .animate(new CurvedAnimation(
                                              parent:
                                                  animationControllers[index],
                                              curve: Curves.elasticOut)),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      _changePageByTabView = true;
                                      setState(() {
                                        _selectTab(index);
                                      });

                                      pageController.animateToPage(index,
                                          duration: widget.changePageDuration,
                                          curve: widget.changePageCurve);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: itemBgColor,
                                      ),
                                      alignment: alignment,
                                      padding: EdgeInsets.all(5),
                                      child: child,
                                    ),
                                  )
                                ],
                              );
                            }),
                      ),
                    ),
                    elevation: widget.tabsElevation,
                    shadowColor: widget.tabsShadowColor,
                    shape: BeveledRectangleBorder(),
                  ),
                  Expanded(
                    child: PageView.builder(
                      scrollDirection: widget.contentScrollAxis,
                      physics: pageScrollPhysics,
                      onPageChanged: (index) {
                        if (_changePageByTabView == false) {
                          _changePageByTabView = null;
                          _selectTab(index);
                        }

                        if (_selectedIndex == index) {
                          _changePageByTabView = null;
                        }
                        setState(() {});
                      },
                      controller: pageController,
                      itemCount: widget.contents.length,
                      itemBuilder: (BuildContext context,int index){
                        return widget.contents[index];
                      },
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _selectTab(index) {
    _selectedIndex = index;
    for (AnimationController animationController in animationControllers) {
      animationController.reset();
    }
    animationControllers[index].forward();

    if(widget.onSelect != null){
      widget.onSelect(_selectedIndex);
    }

  }
}
