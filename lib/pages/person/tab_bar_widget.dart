import 'package:flutter/material.dart';

class TabBarWidget extends StatefulWidget {
  final TabController tabController;
  final List<String> tabTxt;
  const TabBarWidget(
      {super.key, required this.tabController, required this.tabTxt});

  @override
  State<TabBarWidget> createState() => _TabBarWidgetState();
}

class _TabBarWidgetState extends State<TabBarWidget> {
  late Color selectColor, unselectedColor;
  late TextStyle selectStyle, unselectedStyle;
  late List<Widget> tabWidgets;

  @override
  void initState() {
    super.initState();
    selectColor = Colors.black;
    unselectedColor = const Color.fromARGB(255, 117, 117, 117);
    selectStyle = TextStyle(fontSize: 18, color: selectColor);
    unselectedStyle = TextStyle(fontSize: 18, color: selectColor);
    tabWidgets = widget.tabTxt
        .map((item) => Text(
              item,
              style: const TextStyle(fontSize: 15),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: widget.tabController,
      tabs: tabWidgets,
      isScrollable: true,
      indicatorColor: selectColor,
      labelColor: selectColor,
      labelStyle: selectStyle,
      unselectedLabelColor: unselectedColor,
      unselectedLabelStyle: unselectedStyle,
      indicatorSize: TabBarIndicatorSize.label,
    );
  }
}
