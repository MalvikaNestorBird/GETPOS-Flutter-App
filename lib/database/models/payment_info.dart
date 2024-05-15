import 'package:hive/hive.dart';
import 'package:nb_posx/database/db_utils/db_constants.dart';

part 'payment_info.g.dart';

@HiveType(typeId: PaymentInfoBoxId) 
class PaymentInfo {
  @HiveField(0)
  final String paymentType;

  @HiveField(1)
  final double amount;

  PaymentInfo({required this.paymentType, required this.amount});

  Map<String, dynamic> toMap() {
    return {
      'paymentType': paymentType,
      'amount': amount,
    };
  }

  factory PaymentInfo.fromMap(Map<String, dynamic> map) {
    return PaymentInfo(
      paymentType: map['paymentType'],
      amount: map['amount'],
    );
  }
}
