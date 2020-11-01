import 'package:flutter/material.dart';
import 'package:upgrade/dao/destination_search_model.dart';
import 'package:upgrade/model/destination_model.dart';

const TYPER = [
  'D',
  'SS'
];

const URL = 'https://sec-m.ctrip.com/restapi/soa2/13558/mobileSuggestV2?_fxpcqlniredt=09031043410934928682';

class DestinationSearchPage extends StatefulWidget {

  final bool hideLeft;
  final String searchUrl;
  final String keyword;
  final String hint;


  DestinationSearchPage({this.hideLeft, this.searchUrl, this.keyword, this.hint});

  @override
  _DestinationSearchPageState createState() => _DestinationSearchPageState();
}

class _DestinationSearchPageState extends State<DestinationSearchPage> {

  DestinationModel destinationSearchModel;
  InputInfoType inputInfoType;
  SuggestTabType suggestTabType;
  SuggestHotDistrictType suggestHotDistrictType;
  SuggestPoiType suggestPoiType;
  SuggestRecommendType suggestRecommendType;
  SuggestPreferType suggestPreferType;
  String keyword;
  int itemsL = 0;
  List<Widget> items = [];

  @override
  void initState() {
    if(widget.keyword != null){
      _onTextChange(widget.keyword);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _appBar(),
          MediaQuery.removePadding(
              removeTop: true,
              context: context,
              child: Expanded(
                flex: 1,
                child: ListView(
                  children: items.length > 0 ? items :[],
                ),
              )
          )
        ],
      ),
    );
  }

  void _onTextChange(String keyword) {}

  _appBar() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0x66000000),Colors.transparent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter
            )
          ),
        )
      ],
    );
  }
}
