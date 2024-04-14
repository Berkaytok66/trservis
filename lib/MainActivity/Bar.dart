import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trservis/ControllerMainPage/ControllerMainPage.dart';
import 'package:trservis/GraficPage/GraficMainPage.dart';
import 'package:trservis/MainPage/AddMainPage/AddMainPage.dart';
import 'package:trservis/SettingPageFile/SettingMainPage.dart';


class Bar extends StatefulWidget {
  const Bar({super.key});

  @override
  State<Bar> createState() => _BarState();
}

class _BarState extends State<Bar> {
  int _selectedIndex = 0;
  NavigationRailLabelType labelType = NavigationRailLabelType.selected;
  bool showLeading = true;
  bool showTrailing = true;
  double groupAlignment = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: <Widget>[
          NavigationRail(
            selectedIndex: _selectedIndex,
            groupAlignment: groupAlignment,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            labelType: labelType,
            leading: showLeading
                ? FloatingActionButton(
                  elevation: 0,
                  onPressed: () {
                // Add your onPressed code here!
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const AddMainPage()));
                  },
                   child: const Icon(Icons.add),
              )
                : const SizedBox(),
                  trailing: showTrailing
                ? IconButton(
                   onPressed: () {
                // Add your onPressed code here!
                  },
                  icon: const Icon(Icons.more_horiz_rounded),
            )
                : const SizedBox(),
            destinations: const <NavigationRailDestination>[
              NavigationRailDestination(
                icon: Icon(Icons.timer_outlined),
                selectedIcon: Icon(Icons.timer_rounded),
                label: Text('İşlemlerim'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.monetization_on_outlined),
                selectedIcon: Icon(Icons.monetization_on),
                label: Text('Kasa'),
              ),
              NavigationRailDestination(
                icon: Icon(CupertinoIcons.graph_circle),
                selectedIcon: Icon(CupertinoIcons.graph_circle_fill),
                label: Text('Gelişim'),
              ),
              NavigationRailDestination(
                icon: Icon(CupertinoIcons.settings),
                selectedIcon: Icon(CupertinoIcons.settings_solid),
                label: Text('Ayarlar'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          // Main content
          Expanded(
            child: _buildPageContent(_selectedIndex),
          ),
        ],
      ),
    );
  }

  Widget _buildPageContent(int selectedIndex) {
    switch (selectedIndex) {
      case 0:
        return const ControllerMainPage();
      case 1:
        return ThirdPage();
      case 2:
        return const GraficMainPage();
      case 3 :
        return const GeneralSettingPage();
      default:
        return const Center(child: Text('Sayfa bulunamadı'));
    }
  }
}



class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Second Page Content'));
  }
}

class ThirdPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Third Page Content'));
  }
}
