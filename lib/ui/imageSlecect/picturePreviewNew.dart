import 'dart:io';

import 'package:flutter/material.dart';

import 'model/product.dart';
import 'pic_swiper.dart';

class PicturePreviewPage extends StatefulWidget {
  final int index;
  final List<Product> pics;



  PicturePreviewPage(this.index, this.pics);

  @override
  State<StatefulWidget> createState() => new _PicturePreviewPage();
}

class _PicturePreviewPage extends State<PicturePreviewPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("照片",style:TextStyle(color: Colors.white),),
      ),
      body: PicSwiper(widget.index,widget.pics),
    );
  }

}

