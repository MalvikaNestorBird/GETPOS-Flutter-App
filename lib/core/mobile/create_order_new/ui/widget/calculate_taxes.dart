import 'package:hive_flutter/hive_flutter.dart';
import 'package:nb_posx/core/service/product/model/category_products_response.dart';
import 'package:nb_posx/database/models/orderwise_tax.dart';
import 'package:nb_posx/database/models/taxes.dart';

class Taxation extends HiveObject {
  String id, itemTaxTemplate, taxType;
  double taxRate, taxationAmount;
  Taxation(
      {required this.id,
      required this.itemTaxTemplate,
      required this.taxType,
      required this.taxRate,
      required this.taxationAmount});
}

class OrderTaxes extends HiveObject {
  String id, itemTaxTemplate, taxType;
  double taxRate, taxationAmount;
  OrderTaxes(
      {required this.id,
      required this.itemTaxTemplate,
      required this.taxType,
      required this.taxRate,
      required this.taxationAmount});
}

class Messages extends HiveObject {
  String? name,taxCategory;
   
    int? isDefault,disabled;
   
   
    
    List<OrderTax>? tax;
 
  Messages(
      {required this.name,
      required this.taxCategory,
      required this.isDefault,
      required this.disabled,
      required this.tax
     });
}
// class OrderTaxationObject extends HiveObject {
//   String id, itemTaxTemplate, taxType;
//   double taxRate, taxationAmount;
//   OrderTaxationObject(
//       {required this.id,
//       required this.itemTaxTemplate,
//       required this.taxType,
//       required this.taxRate,
//       required this.taxationAmount});
// }