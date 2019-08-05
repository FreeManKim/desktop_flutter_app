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

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'colors.dart';
import 'model/app_state_model.dart';
import 'model/product.dart';
import 'supplemental/asymmetric_view.dart';

// 后边的列表
class CategoryMenuPage extends StatefulWidget {
  const CategoryMenuPage({
    Key key,
    this.onCategoryTap,
  }) : super(key: key);

  final VoidCallback onCategoryTap;

  @override
  State<StatefulWidget> createState() => new _CategoryMenuPage();
}

class _CategoryMenuPage extends State<CategoryMenuPage> {
  Product _product;

  Widget _buildCategory(Category category, BuildContext context) {
    final String categoryString =
        category.toString().replaceAll('Category.', '').toUpperCase();
    final ThemeData theme = Theme.of(context);
    return ScopedModelDescendant<AppStateModel>(
      builder: (BuildContext context, Widget child, AppStateModel model) =>
          GestureDetector(
        onTap: () {
          model.setCategory(category);
          if (widget.onCategoryTap != null) {
            widget.onCategoryTap();
          }
        },
        child: model.selectedCategory == category
            ? Column(
                children: <Widget>[
                  const SizedBox(height: 16.0),
                  Text(
                    categoryString,
                    style: theme.textTheme.body2,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 14.0),
                  Container(
                    width: 70.0,
                    height: 2.0,
                    color: kShrinePink400,
                  ),
                ],
              )
            : Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  categoryString,
                  style: theme.textTheme.body2
                      .copyWith(color: kShrineBrown900.withAlpha(153)),
                  textAlign: TextAlign.center,
                ),
              ),
      ),
    );
  }

  Widget _buildListTitle(
      Product product, BuildContext context, List<Product> list) {
    final String categoryString = product.name;
    final ThemeData theme = Theme.of(context);

    return ScopedModelDescendant<AppStateModel>(
      builder: (BuildContext context, Widget child, AppStateModel model) {
        var selected = product.isAdd;
        var ontap = false;
        return Material(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
          ),
          color: selected ?Color(0xFF80CBC4): Colors.transparent,
          child: ListTile(
            title: Stack(
              children: <Widget>[
                Text(categoryString),
              ],
            ),
            selected: selected,
            onTap: () {
              model.setFolderName(product.parents);
              setState(() {
                for (var i = 0; i < list.length; ++i) {
                  var o = list[i];
                  if (o == product) {
                    product.isAdd = true;
                  } else {
                    o.isAdd = false;
                  }
                }
              });
              if (widget.onCategoryTap != null) {
                widget.onCategoryTap();
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildCategoryNew(
      Product product, BuildContext context, List<Product> list) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: _buildListTitle(product, context, list));
//    final String categoryString = product.name;
//    final ThemeData theme = Theme.of(context);
//    return ScopedModelDescendant<AppStateModel>(
//      builder: (BuildContext context, Widget child, AppStateModel model) =>
//          GestureDetector(
//        onTap: () {
////          model.setCategory(Category.accessories);
//          model.setFolderName(product.parents);
//          if (widget.onCategoryTap != null) {
//            widget.onCategoryTap();
//          }
//        },
//        child: model.selectedCategory == Category.accessories
//            ? Column(
//                children: <Widget>[
//                  const SizedBox(height: 16.0),
//                  Text(
//                    categoryString,
//                    style: theme.textTheme.body2,
//                    textAlign: TextAlign.center,
//                  ),
//                  const SizedBox(height: 14.0),
//                  Container(
//                    width: 70.0,
//                    height: 2.0,
//                    color: kShrinePink400,
//                  ),
//                ],
//              )
//            : Padding(
//                padding: const EdgeInsets.symmetric(vertical: 16.0),
//                child: Text(
//                  categoryString,
//                  style: theme.textTheme.body2
//                      .copyWith(color: kShrineBrown900.withAlpha(153)),
//                  textAlign: TextAlign.center,
//                ),
//              ),
//      ),
//    );
  }

  @override
  void initState() {
    super.initState();
  }

  getListWidget(BuildContext context, Widget child, AppStateModel model) {
    var allCategories = model.getCategorys();
    final List<Widget> backdropItems =
        allCategories.map<Widget>((Product product) {
      final bool selected = product == _product;
      return Material(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
        ),
        color: selected ? Colors.white.withOpacity(0.25) : Colors.transparent,
        child: ListTile(
          title: Text(product.name),
          selected: selected,
          onTap: () {
            model.setFolderName(product.parents);
            if (widget.onCategoryTap != null) {
              widget.onCategoryTap();
            }
          },
        ),
      );
    }).toList();
    final ThemeData theme = Theme.of(context);

    return Container(
        color: kShrinePink100,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: backdropItems,
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppStateModel>(
        builder: (BuildContext context, Widget child, AppStateModel model) {
//      return getListWidget(context, child, model);

      return Center(
        child: Container(
          padding: const EdgeInsets.only(top: 40.0),
          color: kShrinePink100,
          child: ListView.builder(
              itemCount: model.getCategorys().length,
              itemBuilder: (BuildContext context, int index) {
                _product = model.getCategorys()[0];
                return _buildCategoryNew(
                    model.getCategorys()[index], context, model.getCategorys());
              }),
//              child: ListView(
//                children: Category.values.map((Category c) => _buildCategory(c, context)).toList(),
//              ),
        ),
      );
    });

//  @override
//  Widget build(BuildContext context) {
//    return Center(
//      child: Container(
//        padding: const EdgeInsets.only(top: 40.0),
//        color: kShrinePink100,
//        child: ListView(
//          children: Category.values.map((Category c) => _buildCategory(c, context)).toList(),
//        ),
//      ),
//    );
  }
}
