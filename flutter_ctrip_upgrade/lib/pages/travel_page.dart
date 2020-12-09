import 'package:flutter/material.dart';
import 'package:upgrade/model/travel_hot_keyword_model.dart';
import 'package:upgrade/model/travel_params_model.dart';
import 'package:upgrade/model/travel_tab_model.dart';
import 'package:upgrade/pages/speak_page.dart';
import 'package:upgrade/pages/travel_tab_page.dart';
import 'package:upgrade/util/navigator_util.dart';
import 'package:upgrade/widget/search_bar.dart';

class TravelPage extends StatefulWidget {
  @override
  _TravelPageState createState() => _TravelPageState();
}

class _TravelPageState extends State<TravelPage> with TickerProviderStateMixin {
  TabController _controller;
  List<Groups> tabs = [];
  TravelTabModel travelTabModel;
  TravelParamsModel travelParamsModel;
  TravelHotKeywordModel travelHotKeywordModel;
  List<HotKeyword> hotKeyWords;
  String defaultText = '试试搜\“花式过五一\”';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(8, 8, 6, 0),
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: SafeArea(
              child: SearchBar(
                searchBarType: SearchBarType.home,
                inputBoxClick: _jumpToSearch,
                defaultText: defaultText,
                speakClick: _jumpToSpeak,
                hintList: hotKeyWords,
                isUserIcon: true,
                rightButtonClick: _jumpToUser,
              ),
            ),
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(left: 2),
            child: TabBar(
              controller: _controller,
              isScrollable: true,
              labelColor: Colors.black,
              labelPadding: EdgeInsets.fromLTRB(8, 6, 8, 0),
              indicatorColor: Color(0xff2FCFBB),
              indicatorPadding: EdgeInsets.all(6),
              indicatorSize: TabBarIndicatorSize.label,
              indicatorWeight: 2.2,
              labelStyle: TextStyle(fontSize: 18),
              unselectedLabelStyle: TextStyle(fontSize: 15),
              tabs: tabs.map<Tab>((Groups tab) {
                return Tab(
                  text: tab.name,
                );
              }).toList(),
            ),
          ),
          Flexible(
            child: Container(
              padding: EdgeInsets.fromLTRB(6, 3, 6, 0),
              child: TabBarView(
                controller: _controller,
                children: tabs.map((Groups tab) {
                  return TravelTabPage(
                    travelUrl: travelParamsModel?.url,
                    params: travelParamsModel?.params,
                    groupChannelCode: tab?.code,
                  );
                }).toList(),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    _controller = TabController(length: 0, vsync: this);
    _loadParams();
    _loadHotKeyword();
    super.initState();
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _jumpToSpeak() {
    NavigatorUtil.push(context, SpeakPage(pageType: 'travel',));
  }
  
  void _jumpToSearch() {
    // NavigatorUtil.push(context, TravelSearchPage(
    //   hint:defaultText,
    //   hideLeft:false
    // ));
  }
  
  void _jumpToUser() {}

  void _loadParams() {}

  void _loadHotKeyword() {}
}
