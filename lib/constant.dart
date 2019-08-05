import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:async';

class Constant {

   Future<Directory> getLocalFile() async {
    // 获取应用目录
    String dir = (await getExternalStorageDirectory()).path;

    return new Directory(dir);
  }
  //C:\\Users\\fanxd\\Pictures
  Future<Directory> _getLocalFile() async {
    // 获取应用目录
    return new Directory("C:\\Users\\fanxd\\Pictures");
  }
}
