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

import 'package:desktop_flutter_app/ui/imageSlecect/model/app_state_model.dart';
import 'package:desktop_flutter_app/ui/imageSlecect/model/product.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';

import '../picturePreviewNew.dart';

// 图片详情card
class ProductCard extends StatelessWidget {
  const ProductCard({this.imageAspectRatio = 33 / 49, this.product,this.index})
      : assert(imageAspectRatio == null || imageAspectRatio > 0);

  final double imageAspectRatio;
  final Product product;
  final int index;

  static const double kTextBoxHeight = 65.0;

  @override
  Widget build(BuildContext context) {
    final NumberFormat formatter = NumberFormat.simpleCurrency(
      decimalDigits: 0,
      locale: Localizations.localeOf(context).toString(),
    );

    final ThemeData theme = Theme.of(context);

    final Image imageWidgetOlde = Image.asset(
      product.assetName,
      package: product.assetPackage,
      fit: BoxFit.cover,
    );

    final Image imageWidget = Image.file(
      product.fileSystemEntity,
      fit: BoxFit.scaleDown,
    );

    final alreadyAdd = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        AspectRatio(
            aspectRatio: imageAspectRatio,
            child: Material(
                color: Colors.black54,
                child: Align(
                  child: Text(
                    "已经添加",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  alignment: Alignment.center,
                ))),
      ],
    );
    final noAdd = Padding(padding: EdgeInsets.all(0));
    Widget getAddWidget() {
      if (product.isAdd)
        return alreadyAdd;
      else
        return noAdd;
    }

    return ScopedModelDescendant<AppStateModel>(
      builder: (BuildContext context, Widget child, AppStateModel model) {
        return GestureDetector(
          onTap: () {
//            model.addProductToCart(product.id);
            var picPage = PicturePreviewPage(
                model.getProducts().indexOf(product), model.getProducts());
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
          child: Stack(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  AspectRatio(
                      aspectRatio: imageAspectRatio, child: imageWidget),
                  SizedBox(
                    height:
                        kTextBoxHeight * MediaQuery.of(context).textScaleFactor,
                    width: 200.0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          product == null ? '' : product.name,
                          style: theme.textTheme.button,
                          softWrap: false,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        FlatButton.icon(
                          onPressed: () {
                            model.addProductToCart(product.id);
                          },
                          icon: const Icon(
                            Icons.add,
                            size: 18.0,
                          ),
                          label: Text(
                            "添 加 到 购 物 车",
                            style: TextStyle(color: Colors.lightBlue),
                          ),
                        )
// 价格标签
//                    const SizedBox(height: 4.0),
//                    Text(
//                      product == null ? '' : formatter.format(product.price),
//                      style: theme.textTheme.caption,
//                    ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                  padding: EdgeInsets.all(16.0),
                  child: InkWell(
                    child: Icon(Icons.add_shopping_cart),
                    onTap: () {
                      model.addProductToCart(product.id);
                    },
                  )),
              getAddWidget(),
            ],
          ),
        );
      },
    );
  }
}
