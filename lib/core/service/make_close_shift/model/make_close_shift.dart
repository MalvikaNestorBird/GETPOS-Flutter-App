import 'package:nb_posx/database/models/payment_reconciliation.dart';

class ClosingShiftResponse {
  late Message message;

  ClosingShiftResponse({required this.message});

  ClosingShiftResponse.fromJson(Map<String, dynamic> json) {
    if (json.isNotEmpty) message = Message.fromJson(json['message']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['message'] = message.toJson();

    return data;
  }
}

class Message {
  late String owner ='';
  late int docstatus = 0;
  late int idx = 0;
  late DateTime? periodStartDate;
  late DateTime? periodEndDate;
  late DateTime? postingDate;
  late String posOpeningShift = "";
  late String company = "";
  late String posProfile = "";
  late double grandTotal = 0.0;
  late double netTotal = 0.0;
  late double totalQuantity = 0.0;
  late String doctype = "";
  late List<dynamic> taxes = [];
  late List<dynamic> posTransactions = [];
  late List<PaymentReconciliation>? paymentReconciliation = [];
  late int isLocal = 0;
  late int unsaved = 0;

  Message({
    required this.owner,
    required this.docstatus,
    required this.idx,
    required this.periodStartDate,
    required this.periodEndDate,
    required this.postingDate,
    required this.posOpeningShift,
    required this.company,
    required this.posProfile,
    required this.grandTotal,
    required this.netTotal,
    required this.totalQuantity,
    required this.doctype,
    required this.taxes,
    required this.posTransactions,
    required this.paymentReconciliation,
    required this.isLocal,
    required this.unsaved,
  });

  Message.fromJson(Map<String, dynamic> json) {
    owner = json['owner'];
    docstatus = json['docstatus'];
    idx = json['idx'];
    periodStartDate = DateTime.parse(json['period_start_date']);
    periodEndDate = DateTime.parse(json['period_end_date']);
    postingDate = DateTime.parse(json['posting_date']);
    posOpeningShift = json['pos_opening_shift'];
    company = json['company'];
    posProfile = json['pos_profile'];
    grandTotal = json['grand_total'];
    netTotal = json['net_total'];
    totalQuantity = json['total_quantity'];
    doctype = json['doctype'];
    taxes = json['taxes'];
    posTransactions = json['pos_transactions'];
    paymentReconciliation = List<PaymentReconciliation>.from(json['payment_reconciliation'].map((x) => PaymentReconciliation.fromJson(x)));
    isLocal = json['__islocal'];
    unsaved = json['__unsaved'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['owner'] = owner;
    data['docstatus'] = docstatus;
    data['idx'] = idx;
    data['period_start_date'] = periodStartDate;
    data['period_end_date'] = periodEndDate;
    data['posting_date'] = postingDate;
    data['pos_opening_shift'] = posOpeningShift;
    data['company'] = company;
    data['pos_profile'] = posProfile;
    data['grand_total'] = grandTotal;
    data['net_total'] = netTotal;
    data['total_quantity'] = totalQuantity;
    data['doctype'] = doctype;
    data['taxes'] = taxes;
    data['pos_transactions'] = posTransactions;
    data['payment_reconciliation'] = paymentReconciliation!.map((x) => x.toJson()).toList();
    data['__islocal'] = isLocal;
    data['__unsaved'] = unsaved;
    return data;
  }
}

class PaymentReconciliation {
 
  late String modeOfPayment;
  late double openingAmount;
  late double closingAmount;
  late double expectedAmount;
  late double difference;

  PaymentReconciliation({
    
    required this.modeOfPayment,
    required this.openingAmount,
    required this.closingAmount,
    required this.expectedAmount,
    required this.difference,
    
  });

  PaymentReconciliation.fromJson(Map<String, dynamic> json) {
    modeOfPayment = json['mode_of_payment'];
    openingAmount = json['opening_amount'];
    closingAmount = json['closing_amount'];
    expectedAmount = json['expected_amount'];
    difference = json['difference'];
    
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
   
    data['mode_of_payment'] = modeOfPayment;
    data['opening_amount'] = openingAmount;
    data['closing_amount'] = closingAmount;
    data['expected_amount'] = expectedAmount;
    data['difference'] = difference;
  
    return data;
  }
}
