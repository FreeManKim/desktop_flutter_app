import 'package:desktop_flutter_app/entity/ImageEntity.dart';
import 'package:desktop_flutter_app/widget/widgets/staggered_grid_view.dart';
import 'package:desktop_flutter_app/widget/widgets/staggered_tile.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import '../constant.dart' as con;
import 'horizontalList.dart';
import 'onItemClick.dart';
import 'selectItem.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> implements OnItemClick {
  con.Constant _constant = new con.Constant();
  final _listFile = <ImageEntity>[];
  final _copyListFile = <ImageEntity>[];

  final _selectListFile = <ImageEntity>[];

  Widget _buildCategoryWidgets() {
    var gridView = GridView.builder(
        itemCount: _copyListFile.length,
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            childAspectRatio: 5 / 4,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10),
        itemBuilder: (BuildContext context, int index) {
          var _textEditingController = new TextEditingController();
          _textEditingController.text = _copyListFile[index].remark;
          _textEditingController.addListener(() {
            print(_textEditingController.text);
            _copyListFile[index].remark = _textEditingController.text;
            if(_listFile.contains(_copyListFile[index])){
              var indexOf = _listFile.indexOf(_copyListFile[index]);
              _listFile[indexOf].remark=_textEditingController.text;
            }
          });
          return new SelectWidget(
            entity: _copyListFile[index],
            index: index,
            list: _copyListFile,
            editingController: _textEditingController,
            onPressed: () {
              setState(() {
                if (!_selectListFile
                    .contains(_copyListFile[index].fileSystemEntity)) {
                  _selectListFile.add(_copyListFile[index]);
                }
                _copyListFile[index].isShow = false;
                copyFileList();
              });
            },
          );
        });
    return gridView;
  }

  Widget _buildStaggeredGridView() {
    return StaggeredGridView.countBuilder(
      crossAxisCount: 4,
      itemCount: _listFile.length,
      itemBuilder: (BuildContext context, int index) => new SelectWidget(
        entity: _listFile[index],
        index: index,
        list: _listFile,
      ),
      staggeredTileBuilder: (int index) =>
          new StaggeredTile.count(2, index % 2 == 0 ? 1 : 2),
      mainAxisSpacing: 0.0,
      crossAxisSpacing: 0.0,
    );
  }

  Widget _buildHorizontaList() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: _selectListFile.length,
      reverse: false,
      itemBuilder: (BuildContext context, int index) => Material(
        color: Colors.black,
        child: Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 5, 0),
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: Image.file(
                    new File(_selectListFile[index].fileSystemEntity.path),
                    width: 150,
                    fit: BoxFit.fitWidth,
                  ),
                ),
                Align(
                    child: InkWell(
                      onTap: () {
                        setState(() {
//                          _listFile.insert(
//                              0,
//                              new ImageEntity(
//                                  fileSystemEntity: _selectListFile[index],
//                                  isShow: true));
                          insertImageEntity(_selectListFile[index]);
                          _selectListFile.removeAt(index);
                        });
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

  insertImageEntity(ImageEntity entity) {
    if (_listFile.contains(entity)) {
      _listFile[_listFile.indexOf(entity)].isShow = true;
      copyFileList();
    }
  }

  copyFileList() {
    _copyListFile.clear();
    for (ImageEntity entity in _listFile) {
      if (entity.isShow) {
        _copyListFile.add(entity);
      } else {
        print(entity.remark);
      }
    }
  }

  @override
  void initState() {
    print("initState");

    _constant.getLocalFile().then((d) {
      d.exists().then((isExists) {
        if (isExists) {
          setState(() {
            if (d.listSync() != null) {
              for (FileSystemEntity entity in d.listSync()) {
                _listFile.add(
                    new ImageEntity(fileSystemEntity: entity, isShow: true));
                copyFileList();
              }
            }
          });
        } else {
          print("文件不存在");
          print(d.path);
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    double _bodyPaddingLeft = 10;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        children: <Widget>[
          _buildCategoryWidgets(),
          Align(
            child: Material(
              child: Container(
                child: _buildHorizontaList(),
//                child:HorizontalListView(selectListFile:_selectListFile,callback: _MyHomePageState()),
                height: 120,
              ),
            ),
            alignment: Alignment.bottomCenter,
          )
        ],
      ),
    );
  }

  @override
  onClick(FileSystemEntity fileSystemEntity, int index) {
    // TODO: implement onClick
    print("onClick");
    print(fileSystemEntity.path);

    return null;
  }
}
