import 'package:flutter/material.dart';
import 'package:ficha/UI/home_page.dart';


Map<String, dynamic> listPreferences = {
  'isDark': false,
  'isBiggerFilter' : false,
  'isSmallerFilter': false
};

void main(){
  runApp(MyApp());
}

final themeNotifier = ValueNotifier(ThemeMode.light);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_,mode,__){
        return MaterialApp(
          home: HomePage(),
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode:mode,
          debugShowCheckedModeBanner: false,

        );
      }
    );
  }
}
