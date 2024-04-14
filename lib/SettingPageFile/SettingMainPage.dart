import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';


class GeneralSettingPage extends StatefulWidget {
  const GeneralSettingPage({Key? key}) : super(key: key);

  @override
  State<GeneralSettingPage> createState() => _GeneralSettingPageState();
}

class _GeneralSettingPageState extends State<GeneralSettingPage> {
  bool light1 = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ayarlar"),
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(
          color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black, // Replace with your color
        ),
      ),
      body: Column(
        children: [
          SwitchListTile(
            title: Text("Tema Ayarı"),
            secondary: Icon(AdaptiveTheme.of(context).mode.isDark ? Icons.nightlight_round : Icons.sunny),
            value: AdaptiveTheme.of(context).mode.isDark, // Tema modunu kontrol et
            onChanged: (bool value) {
              if (value) {
                AdaptiveTheme.of(context).setDark();

              } else {
                AdaptiveTheme.of(context).setLight();

              }
              setState(() {}); // Widget'ı yeniden çizdir
            },
          ),

          Divider(),
        ],
      ),
    );
  }
}
