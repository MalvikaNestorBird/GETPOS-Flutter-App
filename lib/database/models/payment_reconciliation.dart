
import 'package:hive/hive.dart';
import 'package:nb_posx/database/db_utils/db_constants.dart';
part 'payment_reconciliation.g.dart';

@HiveType(typeId: PaymentReconciliationBoxId)
class PaymentReconciliation extends HiveObject {

    @HiveField(1)
    String modeOfPayment;
    @HiveField(2)
    double openingAmount;
    @HiveField(3)
    double closingAmount;
    @HiveField(4)
    double expectedAmount;
    @HiveField(5)
    double difference;

    PaymentReconciliation({
         this.modeOfPayment = "",
         this.openingAmount = 0.0,
         this.closingAmount = 0.0,
     this.expectedAmount = 0.0,
        this.difference = 0.0,
    });

    factory PaymentReconciliation.fromMap(Map<String, dynamic> json) => PaymentReconciliation(
        modeOfPayment: json["mode_of_payment"] ?? "",
        openingAmount: json["opening_amount"] ?? 0.0 ,
        closingAmount: json["closing_amount"] ?? 0.0,
        expectedAmount: json["expected_amount"] ?? 0.0,
        difference: json["difference"] ?? 0.0,
    );

    Map<String, dynamic> toMap() => {
        "mode_of_payment": modeOfPayment,
        "opening_amount": openingAmount,
        "closing_amount": closingAmount,
        "expected_amount": expectedAmount,
        "difference": difference,
    };

factory PaymentReconciliation.fromJson(Map<String, dynamic> json) {
    return PaymentReconciliation(
      modeOfPayment: json['mode_of_payment'] ?? '',
      openingAmount: json['opening_amount'] != null ? json['opening_amount'].toDouble() : 0.0,
      closingAmount: json['closing_amount'] != null ? json['closing_amount'].toDouble() : 0.0,
      expectedAmount: json['expected_amount'] != null ? json['expected_amount'].toDouble() : 0.0,
      difference: json['difference'] != null ? json['difference'].toDouble() : 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'mode_of_payment': modeOfPayment,
      'opening_amount': openingAmount,
      'closing_amount': closingAmount,
      'expected_amount': expectedAmount,
      'difference': difference,
    };
    return data;
  }

    
}
