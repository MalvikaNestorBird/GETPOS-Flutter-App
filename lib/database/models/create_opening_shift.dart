import 'package:hive/hive.dart';
import 'package:nb_posx/database/db_utils/db_constants.dart';
import 'package:nb_posx/database/models/balance_details.dart';

part 'create_opening_shift.g.dart';

@HiveType(typeId: CreateShiftManagementBoxId)

class CreateOpeningShiftDb {

  @HiveField(1)
  String name;

  @HiveField(2)
  DateTime periodStartDate;

  @HiveField(3)
  DateTime? periodEndDate; 

  @HiveField(4)
  String status;

  @HiveField(5)
  DateTime? postingDate; 

  @HiveField(6)
  int setPostingDate;

  @HiveField(7)
  String company;

  @HiveField(8)
  String posProfile;

  @HiveField(9)
  String doctype;

  @HiveField(10)
  List<BalanceDetail> balanceDetails;

  CreateOpeningShiftDb({
    required this.name,
    required this.periodStartDate,
    required this.periodEndDate,
    required this.status,
    required this.postingDate,
    required this.setPostingDate,
    required this.company,
    required this.posProfile,
    required this.doctype,
    required this.balanceDetails,
  });

Map<String, dynamic> toMap(){
  return {
    'name': name,
    'period_start_date': periodStartDate.toIso8601String(),
    'period_end_date': periodEndDate?.toIso8601String(), 
    'status': status,
    'posting_date': postingDate?.toIso8601String(),
    'set_posting_date': setPostingDate,
    'company': company,
    'pos_profile': posProfile,
    'doctype': doctype,
    'balanceDetails': balanceDetails.map((detail) => detail.toJson()).toList(),
  };
}

 factory CreateOpeningShiftDb.fromMap(Map<String, dynamic> map) {
    return CreateOpeningShiftDb(
      name: map['name'],
      periodStartDate: map['period_start_date'],
      periodEndDate: map['period_end_date'],
      status: map['status'],
      postingDate: map['posting_date'],
      setPostingDate: map['set_posting_date'],
      company: map['company'],
      posProfile: map['pos_profile'],
      doctype: map['doctype'],
      balanceDetails: map['balanceDetails'],
    );
  }

  factory CreateOpeningShiftDb.fromJson(Map<String, dynamic> json) {
    return CreateOpeningShiftDb(
      name: json["name"],
      periodStartDate: DateTime.parse(json["period_start_date"]),
      periodEndDate: json["period_end_date"] != null ? DateTime.parse(json["period_end_date"]) :DateTime.now(),
      status: json["status"],
      postingDate: json["posting_date"] != null ? DateTime.parse(json["posting_date"]) : null,
      setPostingDate: json["set_posting_date"],
      company: json["company"],
      posProfile: json["pos_profile"],
      doctype: json["doctype"],
      balanceDetails: List<BalanceDetail>.from(json["balance_details"].map((x) => BalanceDetail.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
  return {
    'name': name,
    'periodStartDate': periodStartDate.toIso8601String(),
    'periodEndDate': periodEndDate?.toIso8601String(),
    'status': status,
    'postingDate': postingDate?.toIso8601String(),
    'setPostingDate': setPostingDate,
    'company': company,
    'posProfile': posProfile,
    'doctype': doctype,
    'balanceDetails': balanceDetails.map((detail) => detail.toJson()).toList(),
  };
}

}