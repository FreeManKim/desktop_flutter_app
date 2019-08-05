import 'package:desktop_flutter_app/ui/imageSlecect/model/app_state_model.dart';
import 'package:desktop_flutter_app/ui/imageSlecect/supplemental/product_card.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'app.dart';
import 'ui/AnimatedListSample.dart';
import 'ui/homePage.dart';
import 'ui/imageSlecect/app.dart';
import 'ui/route.dart';

void main() {
  runApp(const GalleryApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application
  AppStateModel    model = AppStateModel()..loadProducts();


  @override
  Widget build(BuildContext context) {
    return ScopedModel<AppStateModel>(
      model: model,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        color: Colors.grey,
        home: ShrineApp(),
      ),
    );

//    return MaterialApp(
//      title: 'Flutter Demo',
//      theme: ThemeData(
//        // This is the theme of your application.
//        //
//        // Try running your application with "flutter run". You'll see the
//        // application has a blue toolbar. Then, without quitting the app, try
//        // changing the primarySwatch below to Colors.green and then invoke
//        // "hot reload" (press "r" in the console where you ran "flutter run",
//        // or simply save your changes to "hot reload" in a Flutter IDE).
//        // Notice that the counter didn't reset back to zero; the application
//        // is not restarted.
//        primarySwatch: Colors.blue,
//      ),
//      routes: RoutePath,
////      home: MyHomePage(title: 'Flutter Demo Home Page'),
////      home: ShrineApp(),
//      home: ShrineApp(),
//    );
  }
}


