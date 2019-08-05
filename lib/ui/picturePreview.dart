import 'dart:io';

import 'package:desktop_flutter_app/entity/ImageEntity.dart';
import 'package:flutter/material.dart';

import '../constant.dart';
import 'pic_swiper.dart';

class PicturePreviewPage extends StatefulWidget {
  final int index;
  final List<ImageEntity> pics;



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
    FileSystemEntity fileSystemEntity =
        ModalRoute.of(context).settings.arguments;
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("照片",style:TextStyle(color: Colors.white),),
      ),
      body: PicSwiper(widget.index,widget.pics),
    );
  }

  Widget buildPageItem(int index, String path) {
    return Image.file(new File(path));
  }
}


class _SimplePage extends StatelessWidget {
  _SimplePage(this.data, {Key key, this.parallaxOffset = 0.0})
      : super(key: key);

  final String data;
  final double parallaxOffset;

  @override
  Widget build(BuildContext context) => Center(
        child: Container(
          color: Theme.of(context).primaryColor,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  data,
                  style: const TextStyle(fontSize: 60.0, color: Colors.white),
                ),
                SizedBox(height: 40.0),
                Transform(
                  transform:
                      Matrix4.translationValues(parallaxOffset, 0.0, 0.0),
                  child: const Text(
                    '左右滑动，这是第二行滚动速度更快的小字',
                    style: const TextStyle(fontSize: 16.0, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
