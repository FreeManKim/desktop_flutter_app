import 'dart:io';

import 'package:desktop_flutter_app/entity/ImageEntity.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'pic_swiper.dart';
import 'picturePreview.dart';

class SelectWidget extends StatefulWidget {
  final ImageEntity entity;
  final List<ImageEntity> list;
  final TextEditingController controller;
  final VoidCallback onPressed;
  final int index;
  final TextEditingController editingController;

  SelectWidget(
      {Key key,
      this.entity,
      this.controller,
      this.index,
      this.list,
      this.onPressed,
      this.editingController})
      : assert(entity != null);

  @override
  State<StatefulWidget> createState() => new _SelectWidgetSate();
}

class _SelectWidgetSate extends State<SelectWidget> {

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    String path = widget.entity.fileSystemEntity.path;

    return Scaffold(
      body: Center(
          child: Card(
              clipBehavior: Clip.antiAlias,
              // 根据设置裁剪内容
              elevation: 5.0,
              // 卡片的z坐标,控制卡片下面的阴影大小
              //  margin: EdgeInsetsDirectional.only(bottom: 30.0, top: 30.0, start: 30.0),// 边距
              semanticContainer: true,
              // 表示单个语义容器，还是false表示单个语义节点的集合，接受单个child，但该child可以是Row，Column或其他包含子级列表的widget
//      shape: Border.all(
//          color: Colors.blue, width: 1.0, style: BorderStyle.solid), // 卡片材质的形状，以及边框
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
              // 圆角
              color: Colors.white,
              child: Stack(
                children: <Widget>[
                  Align(
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: Stack(
                              children: <Widget>[
                                InkWell(
                                  child: Image.file(
                                    new File(
                                        widget.entity.fileSystemEntity.path),
                                    fit: BoxFit.fill,
                                    width: 500,
                                    height: 500,
                                  ),
                                  onTap: () {
//                                    Navigator.of(context).pushNamed(picturePreview,arguments:widget.entity );
                                    var page =
                                        PicSwiper(widget.index, widget.list);
                                    var picPage = PicturePreviewPage(
                                        widget.index, widget.list);
                                    Navigator.push(
                                        context,
                                        Platform.isAndroid
                                            ? TransparentMaterialPageRoute(
                                                builder: (_) {
                                                return picPage;
                                              })
                                            : TransparentCupertinoPageRoute(
                                                builder: (_) {
                                                return picPage;
                                              }));
                                  },
                                ),
                                Align(
                                  child: Container(
                                    color: Colors.grey[200],
                                    margin: EdgeInsets.all(10),
                                    child: Text("#" +
                                        path.substring(
                                            path.lastIndexOf("/") + 1)),
                                  ),
                                  alignment: Alignment.bottomLeft,
                                ),
                              ],
                            ),
                            flex: 6,
                          ),
                          Padding(padding: EdgeInsets.all(1)),
                          Expanded(
                            child: TextFormField(
                              controller: widget.editingController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(), hintText: "输入"),
                            ),
                            flex: 1,
                          ),
                          Padding(padding: EdgeInsets.all(1)),
                          Expanded(
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: RaisedButton(
                                    onPressed: (){
                                      widget.onPressed();
                                    },
                                    //通过控制 Text 的边距来控制控件的高度
                                    child: FlatButton.icon(
                                      label: Text(
                                        '添加',
                                        semanticsLabel: 'Add',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      icon: Icon(
                                        Icons.add,
                                        color: Colors.white,
                                        semanticLabel: 'Add',
                                      ),
                                    ),
                                    color: Colors.blue,
                                  ),
                                  flex: 1,
                                ),
                              ],
                            ),
                            flex: 1,
                          )
                        ],
                      ),
                      alignment: Alignment.center),
                ],
              ))),
    );
  }
}
