import 'package:flutter/material.dart';
import 'package:upgrade/model/common_model.dart';
import 'package:upgrade/model/grid_nav_model.dart';
import 'package:upgrade/model/sales_box_model.dart';
import 'package:upgrade/widget/loading_container.dart';

const AppBAR_SCROLL_OFFSET = 100;
const SEARCH_BAR_DEFAULT_REXT = "目的地 ｜ 酒店｜景点｜航班号";

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = false;
  double appbarAlpha = 0;
  List<CommonModel> localNavList = [];
  GridNavModel gridNavModel;
  List<CommonModel> subNavList = [];
  SalesBoxModel salesBoxModel;

  List<CommonModel> bannerList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _handleRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfffafafc),
      body: LoadingContainer(
        isLoading: _isLoading,
        child: Stack(
          children: [
            MediaQuery.removeViewPadding(
                context: context,
                removeTop: true,
                child: NotificationListener(
                  onNotification: (scrollNotification) {
                    if (scrollNotification is ScrollUpdateNotification &&
                        scrollNotification.depth == 0) {
                      _onScroll(scrollNotification.metrics.pixels);
                    }
                    return true;
                  },
                  child: RefreshIndicator(
                    onRefresh: _handleRefresh,
                  ),
                ))
          ],
        ),
      ),
    );
  }

  void _onScroll(offset) {
    double alpha = offset / AppBAR_SCROLL_OFFSET;
    if (alpha < 0) {
      alpha = 0;
    } else if (alpha > 1) {
      alpha = 1;
    } else {}
    setState(() {
      appbarAlpha = alpha;
    });
    print(alpha);
  }

  /**
   * 网络请求数据
   */
  Future<Null> _handleRefresh() async {
    try {} catch (e) {}
  }
}
