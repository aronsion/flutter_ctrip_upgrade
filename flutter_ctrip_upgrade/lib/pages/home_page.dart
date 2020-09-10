import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:upgrade/home_dao.dart';
import 'package:upgrade/model/common_model.dart';
import 'package:upgrade/model/grid_nav_model.dart';
import 'package:upgrade/model/home_model.dart';
import 'package:upgrade/model/sales_box_model.dart';
import 'package:upgrade/widget/grid_nav_new.dart';
import 'package:upgrade/widget/loading_container.dart';
import 'package:upgrade/widget/local_nav.dart';
import 'package:upgrade/widget/square_swiper_pagination.dart';
import 'package:upgrade/widget/webview.dart';

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
                    if (scrollNotification is ScrollUpdateNotification && scrollNotification.depth == 0) {
                      _onScroll(scrollNotification.metrics.pixels);
                    }
                    return true;
                  },
                  child: RefreshIndicator(
                    onRefresh: _handleRefresh,
                    child: ListView(
                      children: [
                        Container(
                          height: 262.0,
                          child: Stack(
                            children: [
                              Container(
                                height: 210.0,
                                child: Swiper(
                                  itemCount: bannerList.length,
                                  autoplay: true,
                                  pagination: SwiperPagination(
                                    builder: SquareSwiperPagination(
                                      size: 6,
                                      activeSize: 6,
                                      color: Colors.white.withAlpha(80),
                                      activeColor: Colors.white
                                    ),
                                    alignment: Alignment.bottomRight,
                                    margin: EdgeInsets.fromLTRB(0, 0, 14, 28)
                                  ),
                                  itemBuilder: (BuildContext context,int index){
                                    return GestureDetector(
                                      onTap: (){
                                        CommonModel model = bannerList[index];
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context)=> WebView(
                                                url:model.url
                                              )
                                            ),
                                        );
                                      },
                                      child: Image.network(
                                        bannerList[index].icon,
                                        fit: BoxFit.fill,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Positioned(
                                top: 188,
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.fromLTRB(14, 0, 14, 0),
                                  child: LocalNav(
                                    localNavList:localNavList
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(14, 0, 14, 0),
                          margin: EdgeInsets.only(top: 10),
                          child: Column(
                            children: [
                              GridNavNew(),
                            ],
                          ),
                        )
                      ],
                    ),
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

  //网络请求数据
  Future<Null> _handleRefresh() async {
    try {
      HomeModel homeModel = await HomeDao.fetch();
      setState(() {
        localNavList = homeModel.localNavList;
        gridNavModel = homeModel.gridNav;
        subNavList = homeModel.subNavList;
        salesBoxModel = homeModel.salesBox;
        bannerList = homeModel.bannerList;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        print(e);
        setState(() {
          _isLoading = false;
        });
      });
    }
  }
}
