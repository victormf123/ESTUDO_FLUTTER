import 'dart:convert';
import 'package:shop/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './cart.dart';

class Order {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime date;

  Order({
    this.id,
    this.amount,
    this.products,
    this.date,
  });
}

class Orders with ChangeNotifier{
  final String _baseUrl = '${Constants.BASE_API_URL}/orders';
  List<Order> _items = [];

  List<Order> get items {
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  Future<void> addOrder(Cart cart) async {
    final date = DateTime.now();
    final response = await http.post(
      "$_baseUrl.json", 
      body: json.encode({
        'amount': cart.totalAmount,
        'date': date.toIso8601String(),
        'products': cart.items.values.map((cartItem) => {
          'id': cartItem.id,
          'productId': cartItem.productId,
          'title': cartItem.title,
          'quantity': cartItem.quantity,
          'price': cartItem.price
        }) .toList()
      }),
    );

      _items.insert(
      0, 
      Order(
        id: json.decode(response.body).toString(),
        amount: cart.totalAmount,
        date: date,
        products: cart.items.values.toList(),
      ));
    notifyListeners();
  }

  Future<void> loadOrders() async {
    List<Order> loadedItems = [];
    final response = await http.get("$_baseUrl.json");
    Map<String, dynamic> data = json.decode(response.body);
    loadedItems.clear();
    if(data != null){
      data.forEach((orderId, orderDara) {
        loadedItems.add(Order(
          id: orderId,
          amount: orderDara['amount'],
          date: DateTime.parse(orderDara['date']),
          products: (orderDara['products'] as List<dynamic>).map((item){
            return CartItem(
              id: item['id'],
              price: item['price'],
              productId: item['productId'],
              quantity: item['quantity'],
              title: item['title']
            );
          }).toList(),
        ));
      });
      notifyListeners();
    }
    _items = loadedItems.reversed.toList();
    return Future.value();
  }
}