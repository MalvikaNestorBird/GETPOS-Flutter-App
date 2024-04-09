import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:nb_posx/database/db_utils/db_constants.dart';
import 'package:nb_posx/database/models/orderwise_tax.dart';
import 'package:nb_posx/database/models/sales_order_req_items.dart';

part 'sales_order_req.g.dart';

@HiveType(typeId: SalesOrderRequestId)
class SalesOrderRequest extends HiveObject {
  @HiveField(0)
  String? name;

  @HiveField(1)
  String? posOpeningShift;

  @HiveField(2)
  String? customer;

  @HiveField(3)
  String? transactionDate;

  @HiveField(4)
  String? deliveryDate;

  @HiveField(5)
  List<SaleOrderRequestItems>? items;

  @HiveField(6)
  String? modeOfPayment;

  @HiveField(7)
  String? mpesaNo;

  @HiveField(8)
  List<OrderTax>? tax;

  @HiveField(9)
  String? hubManager;
 

  SalesOrderRequest({
    this.name,
    required this.posOpeningShift,
    required this.hubManager,
    required this.customer,
    required this.transactionDate,
    required this.deliveryDate,
    required this.items,
    required this.modeOfPayment,
    this.mpesaNo,
    this.tax,
  });

  SalesOrderRequest copyWith({
    String? name,
    String? posOpeningShift,
    String? hubManager,
    String? customer,
    String? transactionDate,
    String? deliveryDate,
    List<SaleOrderRequestItems>? items,
    String? modeOfPayment,
    String? mpesaNo,
    List<OrderTax>? tax,
  }) {
    return SalesOrderRequest(
      name: name ?? this.name,
      posOpeningShift: posOpeningShift ?? this.posOpeningShift,
      hubManager: hubManager ?? this.hubManager,
      customer: customer ?? this.customer,
      transactionDate: transactionDate ?? this.transactionDate,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      items: items ?? this.items,
      modeOfPayment: modeOfPayment ?? this.modeOfPayment,
      mpesaNo: mpesaNo ?? this.mpesaNo,
      tax: tax ?? this.tax,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'pos_profile': name,
      'pos_opening_shift': posOpeningShift, 
      'hub_manager': hubManager,
      'customer': customer,
      'transaction_date': transactionDate,
      'delivery_date': deliveryDate,
      'items': items!.map((x) => x.toMap()).toList(),
      'mode_of_payment': modeOfPayment,
      'mpesa_No': mpesaNo,
      'tax':tax?.map((x) => x.toMap()).toList(),
    };
  }

  factory SalesOrderRequest.fromMap(Map<String, dynamic> map) {
    return SalesOrderRequest(
      name: map['name'],
      posOpeningShift: map['pos_opening_shift'],
      hubManager: map['hub_manager'],
      customer: map['customer'],
      transactionDate: map['transaction_date'],
      deliveryDate: map['delivery_date'],
      items: List<SaleOrderRequestItems>.from(map['selected_option']?.map((x) => SaleOrderRequestItems.fromMap(x))),
      modeOfPayment: map['mode_of_payment'],
      mpesaNo: map['mpesa_no'],
      tax:List<OrderTax>.from(map['tax']?.map((x) => OrderTax.fromMap(x)),
    ),
    );
  }

  String toJson() => json.encode(toMap());

  factory SalesOrderRequest.fromJson(String source) =>
      SalesOrderRequest.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SaleOrder( name:$name, pos_opening_shift: $posOpeningShift, hubManager: $hubManager, customer: $customer, transaction_date: $transactionDate items: $items, mode_of_payment: $modeOfPayment, mpesa_no: $mpesaNo ,tax: $tax)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SalesOrderRequest &&
        other.name == name &&
        other.posOpeningShift == posOpeningShift &&
        other.hubManager == hubManager &&
        other.customer == customer &&
        other.items == items &&
        listEquals(other.items, items) &&
        other.modeOfPayment == modeOfPayment &&
        other.mpesaNo == mpesaNo &&
        other.tax == tax;
  }

  @override
  int get hashCode {
    return
        name.hashCode ^
        posOpeningShift.hashCode ^
        hubManager.hashCode ^
        customer.hashCode ^
        items.hashCode ^
        modeOfPayment.hashCode ^
        mpesaNo.hashCode ^
        tax.hashCode;
  }
}
