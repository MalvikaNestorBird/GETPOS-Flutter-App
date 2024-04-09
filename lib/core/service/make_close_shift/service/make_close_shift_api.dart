import 'dart:convert';
import 'dart:developer';
import 'package:nb_posx/core/service/make_close_shift/model/make_close_shift.dart' as make_close_shift;
import 'package:nb_posx/constants/app_constants.dart';
import 'package:nb_posx/database/db_utils/db_create_opening_shift.dart';
import 'package:nb_posx/database/db_utils/db_shift_management.dart';
import 'package:nb_posx/database/models/create_opening_shift.dart';
import 'package:nb_posx/database/models/payment_reconciliation.dart' as reconciliation;
import 'package:nb_posx/database/models/shift_management.dart';
import 'package:nb_posx/network/api_constants/api_paths.dart';
import 'package:nb_posx/network/api_helper/api_status.dart';
import 'package:nb_posx/network/api_helper/comman_response.dart';
import 'package:nb_posx/network/service/api_utils.dart';
import 'package:nb_posx/utils/helper.dart';


class ClosingShiftService {
  static Future<CommanResponse> fetchClosingShiftData() async {
    CreateOpeningShiftDb? fetchOpeningShiftRequest;

    if (!(await Helper.isNetworkAvailable())) {
      return CommanResponse(
        status: false,
        message: NO_INTERNET,
        apiStatus: ApiStatus.NO_INTERNET,
      );
    }

    try {
      String apiUrl = MAKE_CLOSING_SHIFT;

      // FETCH OPENING SHIFT DATA
      var posProfileId = await DbCreateShift().getOpeningShiftData();

      // REQUEST BODY: USE OF CREATE OPENING SHIFT VOUCHER API RESPONSE
      fetchOpeningShiftRequest = CreateOpeningShiftDb(
        name: posProfileId!.name,
        periodStartDate: posProfileId.periodStartDate,
        periodEndDate: posProfileId.periodEndDate,
        status: posProfileId.status,
        postingDate: posProfileId.postingDate,
        setPostingDate: posProfileId.setPostingDate,
        company: posProfileId.company,
        posProfile: posProfileId.posProfile,
        doctype: posProfileId.doctype,
        balanceDetails: posProfileId.balanceDetails,
      );

    var body = fetchOpeningShiftToMap(fetchOpeningShiftRequest);
log('Request body: $body');

// var body = fetchOpeningShiftToMap(fetchOpeningShiftRequest);
//       log('Request body: $body');


      // POST TYPE REQUEST
      var apiResponse = await APIUtils.postRequest(apiUrl, body);
      log('Api Response::$apiResponse');

     make_close_shift. ClosingShiftResponse resp =  make_close_shift.ClosingShiftResponse.fromJson(apiResponse);
      log("Api Response: $apiResponse");

//Future<ShiftManagement>? closingShift ;

   ShiftManagement closingShift = ShiftManagement();
      // FETCH POS OPENING SHIFT DATA
      if (resp.message.posOpeningShift.isNotEmpty) {
         List<reconciliation.PaymentReconciliation> paymentReconciliation =[];

         //to make the response.message.paymentReconciliation as hive list to avoid the issue of casting datatype
        resp.message.paymentReconciliation!.forEach((element) {
          paymentReconciliation.add(reconciliation.PaymentReconciliation(
              modeOfPayment: element.modeOfPayment,
              openingAmount: element.openingAmount,
              closingAmount: element.closingAmount,
              expectedAmount: element.expectedAmount,
              difference: element.difference));
        });
         
          closingShift = ShiftManagement(
          periodStartDate: resp.message.periodStartDate!,
          periodEndDate: resp.message.periodEndDate!,
          postingDate: resp.message.postingDate!,
          posOpeningShift: resp.message.posOpeningShift,
          posProfile: resp.message.posProfile,
          doctype: resp.message.doctype,
          paymentReconciliation: paymentReconciliation
        );

        // Check this DB as it is used in open shift too
        DbShiftManagement().saveShiftManagementData(closingShift);
        
      }

      return CommanResponse(
        status: true,
        message: closingShift,
        apiStatus: ApiStatus.REQUEST_SUCCESS,
      );
    } catch (e) {
      // ignore: avoid_print
      print("Error occurred: $e");
      return CommanResponse(
        status: false,
        message: "An error occurred: $e",
        apiStatus: ApiStatus.FAILED,
      );
    }
  }

 static Map<String, dynamic> fetchOpeningShiftToMap(CreateOpeningShiftDb openingShift) {
  // Function to format DateTime objects to string with "T" replaced by space
  String formatDate(DateTime dateTime) {
    return dateTime.toIso8601String().replaceAll('T', ' ');
  }

  Map<String, dynamic> shiftMap = {
    'name': openingShift.name,
    'period_start_date': formatDate(openingShift.periodStartDate),
    'status': openingShift.status,
    'posting_date': openingShift.postingDate != null ? formatDate(openingShift.postingDate!) : null, // Convert DateTime to string
    'set_posting_date': openingShift.setPostingDate,
    'company': openingShift.company,
    'pos_profile': openingShift.posProfile,
    'doctype': openingShift.doctype,
    'balance_details': openingShift.balanceDetails.map((detail) => detail.toJson()).toList(),
  };

  // Check if periodEndDate is not null before adding it to the map
  if (openingShift.periodEndDate != null) {
    shiftMap['period_end_date'] = formatDate(openingShift.periodEndDate!); // Convert DateTime to string
  }

  return {'opening_shift': shiftMap};
}


}
