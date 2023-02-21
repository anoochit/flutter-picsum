import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:picsum/pages/show_image.dart';

import 'pages/home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
        builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: lightDynamic,
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: darkDynamic,
        ),
        home: HomePage(),
        getPages: [
          GetPage(
            name: '/',
            page: () => HomePage(),
          ),
          GetPage(
            name: '/show',
            page: () => ShowImage(),
          ),
        ],
      );
    });
  }
}
