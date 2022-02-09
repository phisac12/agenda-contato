// @dart=2.9
import 'package:agenda_contatos/ui/home_page.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
      DevicePreview(
        enabled: false,
        builder: (context) => MaterialApp(
          debugShowCheckedModeBanner: false,
          home: const HomePage(),
          useInheritedMediaQuery: true,
          locale: DevicePreview.locale(context),
          builder: DevicePreview.appBuilder,
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
        ))// Wrap your app
      );

}