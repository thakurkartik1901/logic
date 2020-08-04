import 'package:oodles/model/payment.dart';

import 'customer.dart';

class Order {
  int id;
  String createdOn;
  Customer customer;
  Payment payment;
  bool pack;
  bool khata;

  Order({
    this.id,
    this.createdOn,
    this.customer,
    this.payment,
    this.pack,
    this.khata,
  });
}
