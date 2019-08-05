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

import 'package:desktop_flutter_app/ui/imageSlecect/model/product.dart';
import 'package:desktop_flutter_app/ui/imageSlecect/model/products_repository.dart';
import 'package:scoped_model/scoped_model.dart';

double _salesTaxRate = 0.06;
double _shippingCostPerItem = 7.0;

class AppStateModel extends Model {
  // All the available products.
  List<Product> _availableProducts;
  List<Product> _categoryProducts;
  List<Product> _copyAvailableProducts = <Product>[];

  // The currently selected category of products.
  Category _selectedCategory = Category.accessories;
  String _folderName = null;

  // The IDs and quantities of products currently in the cart.
  final Map<int, int> _productsInCart = <int, int>{};

  Map<int, int> get productsInCart => Map<int, int>.from(_productsInCart);

  // Total number of items in the cart.
  int get totalCartQuantity =>
      _productsInCart.values.fold(0, (int v, int e) => v + e);

  Category get selectedCategory => _selectedCategory;

  // Totaled prices of the items in the cart.
  double get subtotalCost {
    return _productsInCart.keys
        .map((int id) => _availableProducts[id].price * _productsInCart[id])
        .fold(0.0, (double sum, int e) => sum + e);
  }

  // Total shipping cost for the items in the cart.
  double get shippingCost {
    return _shippingCostPerItem *
        _productsInCart.values.fold(0.0, (num sum, int e) => sum + e);
  }

  // Sales tax for the items in the cart
  double get tax => subtotalCost * _salesTaxRate;

  // Total cost to order everything in the cart.
  double get totalCost => subtotalCost + shippingCost + tax;

  // Returns a copy of the list of available products, filtered by category.
  List<Product> getProducts() {
    if (_availableProducts == null) {
      return <Product>[];
    }

    if (_selectedCategory == Category.all) {
      return List<Product>.from(_availableProducts);
    } else {
      return _availableProducts
          .where((Product p) => p.category == _selectedCategory)
          .toList();
    }
  }

  // Adds a product to the cart.
  // 添加照片到购物车
  void addProductToCart(int productId) {
    if (!_productsInCart.containsKey(productId)) {
      getProductById(productId).isAdd = true;
      _productsInCart[productId] = 1;
    } else {
      // 重复添加
//      _productsInCart[productId]++;
    }

    notifyListeners();
  }

  // Removes an item from the cart.
  void removeItemFromCart(int productId) {
    if (_productsInCart.containsKey(productId)) {
      if (_productsInCart[productId] == 1) {
        _productsInCart.remove(productId);
        getProductById(productId).isAdd = false;
      } else {
        _productsInCart[productId]--;
      }
    }
    notifyListeners();
  }

  // 复制 _availableProducts
  copyAvailableProducts() {
    _copyAvailableProducts.clear();
    _copyAvailableProducts.addAll(_availableProducts);
  }

  // Returns the Product instance matching the provided id.
  Product getProductById(int id) {
    return _availableProducts.firstWhere((Product p) => p.id == id);
  }

  // Removes everything from the cart.
  void clearCart() {
    createCategoryFolder();
    _productsInCart.clear();
    notifyListeners();
  }

  void createCategoryFolder() async {
    List<Product> list = <Product>[];
    _productsInCart.forEach((key, value) {
      print("value=>$value key=>$key");
      var product = getProductById(key);
      _availableProducts.remove(product);
      print("length=>>>${_availableProducts.length}");
      list.add(product);
    });
    notifyListeners();
    if (list != null && list.length > 0)
      ProductsRepository.createCategoryFolder(list).then((path) {
        print(path);
      });
  }

  // Loads the list of available products from the repo.
  void loadProducts() async {
    ProductsRepository.loadImages(Category.all).then((onValue) {
      _categoryProducts = onValue;
      notifyListeners();
      loadProductsForName();
    });
  }

  // Loads the list of available products from the repo.
  void loadProductsForName() async {
    print("父目录==》$_folderName");
    _productsInCart.clear();
    if (_folderName != null) {
      ProductsRepository.loadImagesForName(new Directory(_folderName))
          .then((onValue) {
        _availableProducts = onValue;
        notifyListeners();
      });
    } else if (_categoryProducts != null && _categoryProducts.length > 0) {
      _folderName = _categoryProducts[0].parents;
      ProductsRepository.loadImagesForName(new Directory(_folderName))
          .then((onValue) {
        _availableProducts = onValue;
        notifyListeners();
      });
    } else {
      print("根目录为空");
    }
  }

  List<Product> getCategorys() {
    if (_categoryProducts == null) {
      return <Product>[];
    }
    return _categoryProducts
        .where((Product p) => p.category == Category.folder)
        .toList();
  }

  void setCategory(Category newCategory) {
    _selectedCategory = newCategory;

    notifyListeners();
  }

  void setFolderName(String name) async {
    _folderName = name;
    notifyListeners();
    loadProductsForName();
  }

   getCurrentCategory() {
    if (_categoryProducts == null) {
      return "照片";
    }
    List<Product> list = _categoryProducts
        .where((Product p) => p.parents == _folderName)
        .toList();
    return list.length > 0 ? list[0].name : "照片";
  }

  @override
  String toString() {
    return 'AppStateModel(totalCost: $totalCost)';
  }
}
