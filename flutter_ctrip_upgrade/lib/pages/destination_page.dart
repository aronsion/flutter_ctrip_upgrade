import 'package:flutter/material.dart';
import 'package:upgrade/model/destination_model.dart';
import 'package:upgrade/plugin/vertical_tab_view.dart';
import 'package:upgrade/widget/loading_container.dart';

class DestinationPage extends StatefulWidget {
  @override
  _DestinationPageState createState() => _DestinationPageState();
}

class _DestinationPageState extends State<DestinationPage> {
  DestinationModel destinationModel;
  List<NavigationPopList> navigationList;
  List<Tab> tabs = [];
  List<Widget> tabPages = [];
  bool _isLoading = true;
  bool _isMore = true;
  int pageIndex, buttonIndex;

  @override
  Widget build(BuildContext context) {
    if (tabs.length > 0 && tabPages.length > 0) {
      setState(() {
        _isLoading = false;
      });
    }
    if (Theme.of(context).platform == TargetPlatform.iOS) {}
    return Scaffold(
      backgroundColor: Colors.white,
      body: LoadingContainer(
        isLoading: _isLoading,
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(top: Theme.of(context).platform == TargetPlatform.iOS?92:86),
              child: VerticalTabView(
                //TODO
              ),
            )
          ],
        ),
      ),
    );
  }
}
