// Copyright 2018-present the Flutter authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'dart:io';

import '../../../constant.dart';
import 'product.dart';
import 'dart:async';

class ProductsRepository {
  static Future<List<Product>> loadImages(Category category) async {
    final _constant = new Constant();
    final _listFile = <Product>[];
    await _constant.getLocalFile().then((d) async{
      await d.exists().then((isExists) async {
        await getImages(isExists, d).then(_listFile.addAll);
      });
    });
    return _listFile;
  }
  static Future<List<Product>> loadImagesForName(Directory d)async {
    print('oye--0002');
    final _listFile = <Product>[];

    print('oye--0003');
    return getImagesNew(true,d);
  }

  static Future<List<Product>> getImagesNew(bool isExists, Directory d) async{
    print('oye--0005');
    final _listFile = <Product>[];
    if (isExists) {
      if (d.listSync() != null) {
        for (var i = 0; i < d.listSync().length; ++i) {
          final file = d.listSync()[i];
          final isFile = FileSystemEntity.isFileSync(file.path);
          if (!isFile) {
            print(file.path);
            _listFile.add(Product(
                category: Category.folder,
                id: i,
                isFeatured: false,
                name: file.path.substring(file.path.lastIndexOf('/') + 1),
                price: 34,
                parents:file.path,
                fileSystemEntity: file,
                isAdd: false));
            continue;
          }
          _listFile.add(Product(
              category: Category.accessories,
              id: i,
              isFeatured: false,
              name: file.path.substring(file.path.lastIndexOf('/') + 1),
              price: 34,
              parents:file.parent.path,
              fileSystemEntity: file,
              isAdd: false));
        }
      } else {
        print('listSync 为空文件不存在');
      }
    } else {
      print('文件不存在');
    }
    _listFile.sort((left, right) {
      // var leftSat = left.fileSystemEntity.statSync();
      // var rightSat = right.fileSystemEntity.statSync();
      return left.name.compareTo(right.name);
    });
    print('oye--0006');

    return _listFile;
  }

  static Future<List<Product>> getImages(bool isExists, Directory d) async  {
    final _listFile = <Product>[];
    if (isExists) {
      if (d.listSync() != null) {
        for (var i = 0; i < d.listSync().length; ++i) {
          final file = d.listSync()[i];
          final isFile = FileSystemEntity.isFileSync(file.path);
          if (!isFile) {
            print(file.path);
            _listFile.add(Product(
                category: Category.folder,
                id: i,
                isFeatured: false,
                name: file.path.substring(file.path.lastIndexOf('/') + 1),
                price: 34,
                parents:file.path,
                fileSystemEntity: file,
                isAdd: false));
            continue;
          }
          _listFile.add(Product(
              category: Category.accessories,
              id: i,
              isFeatured: false,
              name: file.path.substring(file.path.lastIndexOf('/') + 1),
              price: 34,
              parents:file.parent.path,
              fileSystemEntity: file,
              isAdd: false));
        }
      } else {
        print('listSync 为空文件不存在');
      }
    } else {
      print('文件不存在');
    }
    _listFile.sort((left, right) {
      // var leftSat = left.fileSystemEntity.statSync();
      // var rightSat = right.fileSystemEntity.statSync();
      return left.name.compareTo(right.name);
    });
    return _listFile;
  }

  static Future<String> createCategoryFolder(List<Product> list) async {
    print('createCategoryFolder${list.length}个');
    final constant = new Constant();
    return await constant.getLocalFile().then((directory) async {
      final path2 = '${directory.path}/test';
      final  dir = new Directory(path2);
      await dir.create();
      for (var i = 0; i < list.length; ++i) {
        final product = list[i];
        final file = new File(product.fileSystemEntity.path);
        final newPath = '${dir.path}/${product.name}';
        await  file.copy(newPath).then((newFile) async {
          await file.delete();
        });
      }
      return dir.path;
    });
  }
}
