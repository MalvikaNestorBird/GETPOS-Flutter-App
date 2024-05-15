// To parse this JSON data, do
//
//     final submitClosingShift = submitClosingShiftFromJson(jsonString);

import 'dart:convert';

SubmitClosingShift submitClosingShiftFromJson(String str) => SubmitClosingShift.fromJson(json.decode(str));

String submitClosingShiftToJson(SubmitClosingShift data) => json.encode(data.toJson());

class SubmitClosingShift {
    ClosingShift closingShift;

    SubmitClosingShift({
        required this.closingShift,
    });

    factory SubmitClosingShift.fromJson(Map<String, dynamic> json) => SubmitClosingShift(
        closingShift: ClosingShift.fromJson(json["closing_shift"]),
    );

    Map<String, dynamic> toJson() => {
        "closing_shift": closingShift.toJson(),
    };
}

class ClosingShift {
    String owner;
    int idx;
    int docstatus;
    String periodStartDate;
    String periodEndDate;
    DateTime postingDate;
    String posOpeningShift;
    String company;
    String posProfile;
    String user;
    int grandTotal;
    int netTotal;
    int totalQuantity;
    String doctype;
    List<dynamic> posTransactions;
    List<PaymentReconciliation> paymentReconciliation;
    List<dynamic> taxes;
    int islocal;
    int unsaved;

    ClosingShift({
        required this.owner,
        required this.idx,
        required this.docstatus,
        required this.periodStartDate,
        required this.periodEndDate,
        required this.postingDate,
        required this.posOpeningShift,
        required this.company,
        required this.posProfile,
        required this.user,
        required this.grandTotal,
        required this.netTotal,
        required this.totalQuantity,
        required this.doctype,
        required this.posTransactions,
        required this.paymentReconciliation,
        required this.taxes,
        required this.islocal,
        required this.unsaved,
    });

    factory ClosingShift.fromJson(Map<String, dynamic> json) => ClosingShift(
        owner: json["owner"],
        idx: json["idx"],
        docstatus: json["docstatus"],
        periodStartDate: json["period_start_date"],
        periodEndDate: json["period_end_date"],
        postingDate: DateTime.parse(json["posting_date"]),
        posOpeningShift: json["pos_opening_shift"],
        company: json["company"],
        posProfile: json["pos_profile"],
        user: json["user"],
        grandTotal: json["grand_total"],
        netTotal: json["net_total"],
        totalQuantity: json["total_quantity"],
        doctype: json["doctype"],
        posTransactions: List<dynamic>.from(json["pos_transactions"].map((x) => x)),
        paymentReconciliation: List<PaymentReconciliation>.from(json["payment_reconciliation"].map((x) => PaymentReconciliation.fromJson(x))),
        taxes: List<dynamic>.from(json["taxes"].map((x) => x)),
        islocal: json["__islocal"],
        unsaved: json["__unsaved"],
    );

    Map<String, dynamic> toJson() => {
        "owner": owner,
        "idx": idx,
        "docstatus": docstatus,
        "period_start_date": periodStartDate,
        "period_end_date": periodEndDate,
        "posting_date": "${postingDate.year.toString().padLeft(4, '0')}-${postingDate.month.toString().padLeft(2, '0')}-${postingDate.day.toString().padLeft(2, '0')}",
        "pos_opening_shift": posOpeningShift,
        "company": company,
        "pos_profile": posProfile,
        "user": user,
        "grand_total": grandTotal,
        "net_total": netTotal,
        "total_quantity": totalQuantity,
        "doctype": doctype,
        "pos_transactions": List<dynamic>.from(posTransactions.map((x) => x)),
        "payment_reconciliation": List<dynamic>.from(paymentReconciliation.map((x) => x.toJson())),
        "taxes": List<dynamic>.from(taxes.map((x) => x)),
        "__islocal": islocal,
        "__unsaved": unsaved,
    };
}

class PaymentReconciliation {
    String parentfield;
    String parenttype;
    int idx;
    int docstatus;
    String modeOfPayment;
    int openingAmount;
    int closingAmount;
    int expectedAmount;
    String difference;
    String doctype;
    int islocal;

    PaymentReconciliation({
        required this.parentfield,
        required this.parenttype,
        required this.idx,
        required this.docstatus,
        required this.modeOfPayment,
        required this.openingAmount,
        required this.closingAmount,
        required this.expectedAmount,
        required this.difference,
        required this.doctype,
        required this.islocal,
    });

    factory PaymentReconciliation.fromJson(Map<String, dynamic> json) => PaymentReconciliation(
        parentfield: json["parentfield"],
        parenttype: json["parenttype"],
        idx: json["idx"],
        docstatus: json["docstatus"],
        modeOfPayment: json["mode_of_payment"],
        openingAmount: json["opening_amount"],
        closingAmount: json["closing_amount"],
        expectedAmount: json["expected_amount"],
        difference: json["difference"],
        doctype: json["doctype"],
        islocal: json["__islocal"],
    );

    Map<String, dynamic> toJson() => {
        "parentfield": parentfield,
        "parenttype": parenttype,
        "idx": idx,
        "docstatus": docstatus,
        "mode_of_payment": modeOfPayment,
        "opening_amount": openingAmount,
        "closing_amount": closingAmount,
        "expected_amount": expectedAmount,
        "difference": difference,
        "doctype": doctype,
        "__islocal": islocal,
    };
}
