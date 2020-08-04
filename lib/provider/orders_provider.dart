import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:oodles/model/customer.dart';
import 'package:oodles/model/order.dart';
import 'package:oodles/model/payment.dart';

class OrderProvider with ChangeNotifier {
  List<Order> _items = [];
  List<Order> _originalItems = [];
  double _amount = 0;

  OrderProvider() {
    fetchTotalAmount();
    fetchAndSetOrders();
  }

  List<Order> get items {
    return [..._items];
  }

  double get amount {
    return _amount;
  }

  Future<void> filterOrdersOnNameBases(String name) {
    List<Order> filteredUsers = [];
    for (Order item in _originalItems) {
      if (item.customer.name.contains(name)) {
        filteredUsers.add(item);
      }
    }
    _items = filteredUsers;
    notifyListeners();
  }

  Future<void> fetchTotalAmount() async {
    final url =
        'https://d3rrgc1io7q2aj.cloudfront.net/qa/api/v2/vapp/vendor/5/report/sale?date=2020-08-04';
    try {
      final response = await http.get(url, headers: {
        'yelo-auth-token':
            'SllzS3VkNVg3UUVMR0JWVVVoWk9NM1p0K203QmNaQkRyTlRodTRtY2MzMD0='
      });
      final extractedData = json.decode(response.body) as dynamic;
      if (extractedData == null) {
        return;
      }
      _amount = extractedData['data']['onlineSale'] ??
          0 + extractedData['data']['cashSale'] ??
          0 + extractedData['data']['khataSale'];

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchAndSetOrders() async {
    final url =
        'https://d3rrgc1io7q2aj.cloudfront.net/qa/api/v2/vapp/order/new?_pageNo=1&_pageSize=50';
    try {
      final response = await http.get(url, headers: {
        'yelo-auth-token':
            'SllzS3VkNVg3UUVMR0JWVVVoWk9NM1p0K203QmNaQkRyTlRodTRtY2MzMD0='
      });
      final extractedData =
          json.decode(response.body)['data']['orders'] as List<dynamic>;
      print(extractedData);
      if (extractedData == null) {
        return;
      }
      List<Order> loadedUsers = [];
      loadedUsers = extractedData
          .map(
            (item) => Order(
              id: item['id'],
              createdOn: item['createdOn'],
              customer: Customer(
                name: item['customer']['name'],
              ),
              payment: Payment(
                mode: item['payment']['mode'],
                amount: item['payment']['amount'],
                paid: item['payment']['paid'],
                time: item['payment']['time'],
              ),
              pack: item['pack'],
              khata: item['khata'],
            ),
          )
          .toList();
      _originalItems = loadedUsers;
      _items = loadedUsers;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> setUsers() async {
    if (_originalItems == null) {
      fetchAndSetOrders();
      return;
    }
    _items = _originalItems;
    notifyListeners();
  }
}
