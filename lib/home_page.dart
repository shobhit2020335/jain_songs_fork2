import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:jain_songs/custom_widgets/constant_widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.navigationShell}) : super(key: key);
  final StatefulNavigationShell navigationShell;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget appBarTitle = ConstWidget.mainAppTitle();
  void onTap(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: const <IconData>[
          FontAwesomeIcons.chartLine,
          Icons.edit_rounded,
          Icons.book_rounded,
          Icons.info_outline_rounded,
        ],
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        inactiveColor: Theme.of(context).primaryColorLight,
        activeColor: ConstWidget.signatureColors(),
        splashColor: ConstWidget.signatureColors(),
        iconSize: 30,
        elevation: 5,
        activeIndex: widget.navigationShell.currentIndex,
        gapLocation: GapLocation.none,
        notchSmoothness: NotchSmoothness.smoothEdge,
        onTap: onTap,
      ),
      body: widget.navigationShell,
    );
  }
}
