import 'package:doworking/fourthpages/view_types_screen.dart';
import 'package:doworking/utils/job_theme.dart';
import 'package:flutter/material.dart';

class TypesScreen extends StatefulWidget {
  TypesScreen({Key key, @required this.currentIndex}) : super(key: key);
  final int currentIndex;
  _TypesScreenState createState() => _TypesScreenState();
}

class _TypesScreenState extends State<TypesScreen>
    with SingleTickerProviderStateMixin {
  List _tabs = ['全部', '已报名', '已录取', '已完成'];
  TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
        length: _tabs.length, vsync: this, initialIndex: widget.currentIndex);
    // _tabs.addAll(widget.list);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  TabBar _tabbar() {
    return TabBar(
      onTap: (index) {},
      labelColor: JobColor.red,
      labelStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
      unselectedLabelStyle:
          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
      unselectedLabelColor: Color(0xFFB0B0B0),
      indicatorColor: JobColor.red,
      // isScrollable: true,
      indicatorWeight: 1,
      indicatorPadding: EdgeInsets.symmetric(
          horizontal: (MediaQuery.of(context).size.width / 4 / 2.4),
          vertical: 5),
      controller: _tabController,
      tabs: List.generate(_tabs.length, (int index) {
        String title = _tabs[index];
        return Container(
          padding: EdgeInsets.symmetric(
            vertical: 10,
          ),
          child: Text(title),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('我的投递'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(44),
          child: Material(
            color: JobColor.white,
            child: _tabbar(),
          ),
        ),
      ),
      body: TabBarView(
        children: _tabs.isEmpty
            ? []
            : List.generate(_tabs.length, (index) {
                return ViewTypesScreen(
                  index: index,
                );
              }),
        controller: _tabController,
      ),
    );
  }
}
