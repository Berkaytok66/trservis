import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:trservis/LoginAndSingin/LoginPage.dart';

// Asenkron bir main fonksiyonu
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Flutter bağlamını başlat
  runApp(const MyApp(savedThemeMode: AdaptiveThemeMode.system)); // Uygulamayı başlat
}

class MyApp extends StatelessWidget {
  final AdaptiveThemeMode savedThemeMode;

  const MyApp({super.key, required this.savedThemeMode});


  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData.light(useMaterial3: true,),
      dark: ThemeData.dark(useMaterial3: true),
      initial: savedThemeMode ?? AdaptiveThemeMode.light,

      builder: (theme, darkTheme) => MaterialApp(
        title: 'Adaptive Theme Demo',
        theme: theme,
        debugShowCheckedModeBanner: false,
        darkTheme: darkTheme,
        home: Login_screen(),
      ),
    );
  }
}
