import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:nb_posx/database/db_utils/db_constants.dart';
import 'package:nb_posx/database/models/payment_reconciliation.dart';
import 'package:nb_posx/database/models/payment_type.dart';
import 'package:nb_posx/database/models/payment_info.dart'; 

part 'shift_management.g.dart';

@HiveType(typeId: ShiftManagementBoxId)
class ShiftManagement extends HiveObject {
  @HiveField(0)
  DateTime? periodStartDate;

  @HiveField(1)
  DateTime? periodEndDate;

  @HiveField(2)
  DateTime? postingDate;

  @HiveField(3)
  String? posOpeningShift;

  @HiveField(4)
  String? company;

  @HiveField(5)
  String? posProfile;

  @HiveField(6)
  String? doctype;

  @HiveField(7)
  List<PaymentType>? paymentsMethod;

  @HiveField(8)
  List<PaymentInfo>? paymentInfoList;

  @HiveField(9)
  List<PaymentReconciliation>? paymentReconciliation;

  ShiftManagement({
    this.periodStartDate,
    this.periodEndDate,
    this.postingDate,
    this.posOpeningShift,
    this.company,
    this.posProfile,
    this.doctype,
    this.paymentsMethod,
    this.paymentInfoList,
    this.paymentReconciliation,
  });

  factory ShiftManagement.fromMap(Map<String, dynamic> map) {
    return ShiftManagement(
      periodStartDate: map['period_start_date'] != null ? DateTime.parse(map['period_start_date']) : null,
      periodEndDate: map['period_end_date'] != null ? DateTime.parse(map['period_end_date']) : null,
      postingDate: map['posting_date'] != null ? DateTime.parse(map['posting_date']) : null,
      posOpeningShift: map['pos_opening_shift'],
      company: map['company'],
      posProfile: map['pos_profile'],
      doctype: map['doctype'],
      paymentsMethod: List<PaymentType>.from((map['paymentsMethod'] ?? []).map((x) => PaymentType.fromMap(x))),
      paymentInfoList: List<PaymentInfo>.from((map['paymentInfoList'] ?? []).map((x) => PaymentInfo.fromMap(x))),
      paymentReconciliation: map['payment_reconciliation']
      //List<PaymentReconciliation>.from((map['payment_reconciliation'] ?? []).map((x) => PaymentReconciliation.fromMap(x))),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'period_start_date': periodStartDate?.toIso8601String(),
      'period_end_date': periodEndDate?.toIso8601String(),
      'posting_date': postingDate?.toIso8601String(),
      'pos_opening_shift': posOpeningShift,
      'company': company,
      'pos_profile': posProfile,
      'doctype': doctype,
      'paymentsMethod': paymentsMethod?.map((payment) => payment.toMap()).toList(),
      'paymentInfoList': paymentInfoList?.map((info) => info.toMap()).toList(),
      'payment_reconciliation': paymentReconciliation?.map((reconciliation) => reconciliation.toMap()).toList(),
    };
  }

  factory ShiftManagement.fromJson(Map<String, dynamic> json) {
    return ShiftManagement(
      periodStartDate: DateTime.parse(json["period_start_date"]),
      periodEndDate: json["period_end_date"] != null ? DateTime.parse(json["period_end_date"]) :DateTime.now(),
      postingDate: json["posting_date"] != null ? DateTime.parse(json["posting_date"]) : null,
      company: json["company"],
      posProfile: json["pos_profile"],
      doctype: json["doctype"],
      paymentReconciliation: List<PaymentReconciliation>.from(json["payment_reconciliation"].map((x) => PaymentReconciliation.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
  return {
   
    'period_start_date': periodStartDate!.toIso8601String(),
    'period_end_date': periodEndDate?.toIso8601String(),
    'posting_date': postingDate?.toIso8601String(),
    'company': company,
    'pos_profile': posProfile,
    'doctype': doctype,
    'payment_reconciliation': paymentReconciliation?.map((detail) => detail.toJson()).toList(),
  };
}
  
  @override
  String toString() {
    return 'ShiftManagement(period_start_date: $periodStartDate, period_end_date: $periodEndDate, posting_date: $postingDate, pos_opening_shift: $posOpeningShift, company: $company, pos_profile: $posProfile, doctype: $doctype, paymentsMethod: $paymentsMethod, paymentInfoList: $paymentInfoList, payment_reconciliation: $paymentReconciliation)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ShiftManagement &&
        other.periodStartDate == periodStartDate &&
        other.periodEndDate == periodEndDate &&
        other.postingDate == postingDate &&
        other.posOpeningShift == posOpeningShift &&
        other.company == company &&
        other.posProfile == posProfile &&
        other.doctype == doctype &&
        other.paymentsMethod == paymentsMethod &&
        other.paymentInfoList == paymentInfoList &&
        other.paymentReconciliation == paymentReconciliation;
  }

  @override
  int get hashCode {
    return periodStartDate.hashCode ^
        periodEndDate.hashCode ^
        postingDate.hashCode ^
        posOpeningShift.hashCode ^
        company.hashCode ^
        posProfile.hashCode ^
        doctype.hashCode ^
        paymentsMethod.hashCode ^
        paymentInfoList.hashCode ^
        paymentReconciliation.hashCode;
  }
}
