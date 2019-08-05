import 'dart:io';

import 'package:flutter/material.dart';

import 'onItemClick.dart';

class HorizontalListView extends StatefulWidget {
  List<FileSystemEntity> selectListFile;
  OnItemClick callback;


  HorizontalListView({this.selectListFile, this.callback,Key key});

  @override
  State<StatefulWidget> createState() => new _HorizontalListView();
}

class _HorizontalListView extends State<HorizontalListView> {
  ScrollController _scrollController;

  @override
  void initState() {
    // TODO: implement initState
    _scrollController = new ScrollController();

    super.initState();
  }

  Widget _buildHorizontaList() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: widget.selectListFile.length,
      //此处为新添加代码------start
      controller: _scrollController,
//此处为新添加代码------end
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) => Material(
        color: Colors.black,
        child: Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 5, 0),
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: Image.file(
                    new File(widget.selectListFile[index].path),
                    width: 150,
                    fit: BoxFit.fitWidth,
                  ),
                ),
                Align(
                    child: InkWell(
                      onTap: () {
                        onTap(widget.selectListFile[index], index);
                      },
                      child: CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.close,
                          size: 20,
                        ),
                      ),
                    ),
                    alignment: Alignment.topRight),
              ],
            )),
      ),
    );
  }

  onTap(FileSystemEntity fileSystemEntity, int index) {
    print(fileSystemEntity.path);
    setState(() {
      widget.selectListFile.removeAt(index);
    });
    widget.callback.onClick(fileSystemEntity, index);

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return _buildHorizontaList();
  }
}
