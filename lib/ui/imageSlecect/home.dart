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

import 'package:desktop_flutter_app/entity/ImageEntity.dart';
import 'package:flutter/material.dart';

import 'package:desktop_flutter_app/ui/imageSlecect/backdrop.dart';
import 'package:desktop_flutter_app/ui/imageSlecect/expanding_bottom_sheet.dart';
import 'package:desktop_flutter_app/ui/imageSlecect/model/app_state_model.dart';
import 'package:desktop_flutter_app/ui/imageSlecect/model/product.dart';
import 'package:desktop_flutter_app/ui/imageSlecect/supplemental/asymmetric_view.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../constant.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({this.category = Category.all});

  final Category category;

  @override
  State<StatefulWidget> createState() => new _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {


  @override
  void initState() {
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppStateModel>(
        builder: (BuildContext context, Widget child, AppStateModel model) {
      return AsymmetricView(products: model.getProducts());
    });
  }
}

class HomePage extends StatelessWidget {
  const HomePage({
    this.expandingBottomSheet,
    this.backdrop,
    Key key,
  }) : super(key: key);

  final ExpandingBottomSheet expandingBottomSheet;
  final Backdrop backdrop;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        backdrop,
        Align(child: expandingBottomSheet, alignment: Alignment.bottomRight),
      ],
    );
  }
}
