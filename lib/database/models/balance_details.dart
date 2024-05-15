import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:nb_posx/database/db_utils/db_constants.dart';

part 'balance_details.g.dart';

@HiveType(typeId: BalanceDetailsBoxId)
class BalanceDetail extends HiveObject {

  @HiveField(10)
  late String modeOfPayment;

  @HiveField(11)
  late double amount;


  BalanceDetail({
    required this.modeOfPayment,
    required this.amount,
  });

  factory BalanceDetail.fromJson(Map<String, dynamic> json) {
    return BalanceDetail(
      modeOfPayment: json['mode_of_payment'],
      amount: json['amount'],
    );
  }

   Map<String, dynamic> toJson() {
    return {
      'mode_of_payment': modeOfPayment,
      'amount': amount,
    };
  }
}
