import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> _item = [];

  final authToken = FirebaseAuth.instance.currentUser!.refreshToken;

  final userId = FirebaseAuth.instance.currentUser!.uid;

  List<Product> get item {
    return [..._item];
  }

  Product findById(String id) {
    return _item.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    final url = Uri.parse(
        'https://ebay-demo-2ec23-default-rtdb.firebaseio.com/products.json?orderBy="creatorId"&equalTo="$userId"');
    try {
      final response = await http.get(url);
      final extractedDataResponseBody = json.decode(response.body);
      if (extractedDataResponseBody == null) {
        return;
      }
      final extractedData = extractedDataResponseBody as Map<String, dynamic>;
      final List<Product> loadedProducts = [];

      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId.toString(),
          title: prodData['title'].toString(),
          description: prodData['description'].toString(),
          price: prodData['price'],
          imageUrl: prodData['imageUrl'].toString(),
          selectedDate: DateTime.parse(prodData['bidEndDateime']),
        ));
      });
      _item = loadedProducts;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse(
        'https://ebay-demo-2ec23-default-rtdb.firebaseio.com/products.json?');
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'title': product.title,
            'descripttion': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
            'creatorId': userId,
            'bidEndDateime': product.selectedDate!.toIso8601String(),
          },
        ),
      );
      final newProduct = Product(
        id: json.decode(response.body)['name'],
        description: product.description,
        title: product.title,
        price: product.price,
        imageUrl: product.imageUrl,
        selectedDate: product.selectedDate,
      );
      _item.add(newProduct);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _item.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url = Uri.parse(
          'https://ebay-demo-2ec23-default-rtdb.firebaseio.com/products/$id.json?');
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'descripttion': newProduct.description,
            'price': newProduct.price,
            'imageUrl': newProduct.imageUrl,
            'bidEndDateime': newProduct.selectedDate!.toIso8601String(),
          }));

      _item[prodIndex] = newProduct;
    } else {
      print('...');
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse(
        'https://ebay-demo-2ec23-default-rtdb.firebaseio.com/products/$id.json?');
    final existingProductIndex = _item.indexWhere((prod) => prod.id == id);
    Product? existingProduct = _item[existingProductIndex];
    _item.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _item.insert(existingProductIndex, existingProduct);
      notifyListeners();
    }
    existingProduct = null;
  }
}
