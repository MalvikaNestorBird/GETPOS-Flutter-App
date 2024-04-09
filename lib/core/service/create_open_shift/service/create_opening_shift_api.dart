import 'dart:developer';
import 'package:nb_posx/constants/app_constants.dart';
import 'package:nb_posx/core/service/create_open_shift/model/create_opening_voucher.dart';
import 'package:nb_posx/database/db_utils/db_balance_details.dart';
import 'package:nb_posx/database/db_utils/db_create_opening_shift.dart';
import 'package:nb_posx/database/db_utils/db_payment_info.dart';
import 'package:nb_posx/database/db_utils/db_pos_profile_cashier.dart';
import 'package:nb_posx/database/models/balance_details.dart';
import 'package:nb_posx/database/models/create_opening_shift.dart';
import 'package:nb_posx/database/models/payment_info.dart';
import 'package:nb_posx/network/api_constants/api_paths.dart';
import 'package:nb_posx/network/api_helper/api_status.dart';
import 'package:nb_posx/network/api_helper/comman_response.dart';
import 'package:nb_posx/network/service/api_utils.dart';
import 'package:nb_posx/utils/helper.dart';
import 'dart:convert'; // Import this for json encoding

class CreateOpeningShiftService {
  Future<CommanResponse> createOpeningShiftDetails(String selectedPosProfile) async {
    // Fetch the company of the selected POS profile from the database
    String? company = await DbPosProfileCashier().getCompanyByProfileName(selectedPosProfile);

    if (company == null) {
      // Handle the case where company is not found
      return CommanResponse(
        status: false,
        message: "Company not found for the selected POS profile",
        apiStatus: ApiStatus.FAILED,
      );
    }

    // Fetch balance details from the database
    List<PaymentInfo> balanceDetail = await DbPaymentInfo().getBalanceDetail();

    if (await Helper.isNetworkAvailable()) {
      try {
        const String apiUrl = CREATE_OPENING_SHIFT;

        // Constructing the request body
        final List<Map<String, dynamic>> balanceDetails = balanceDetail.map((paymentInfo) {
          return {
            'mode_of_payment': paymentInfo.paymentType,
            'amount': paymentInfo.amount,
          };
        }).toList();

// Convert balance details to a JSON string
  String balanceDetailsJson = json.encode(balanceDetails);

        final body = {
          'pos_profile': selectedPosProfile, 
          'company': company,
          'balance_details': balanceDetailsJson,
        };

// Convert the data to JSON with indentation
  String jsonStr = const JsonEncoder.withIndent("").convert(body);

  // Print the JSON string
  print(jsonStr);
        
        // Make the POST request
        final apiResponse = await APIUtils.postRequest(apiUrl, body);
        log(apiResponse.toString());

        final resp = CreateOpeningShiftResponse.fromJson(apiResponse);

        // Check if the response message is not null
        if (resp.message != null) {
          // FETCH POS OPENING SHIFT FROM MESSAGE OBJECT
          final openingShift = resp.message!.createOpeningShift;

          if (openingShift != null) {
            final cashiers = CreateOpeningShiftDb(
              name: openingShift.name,
              company: company,
              periodStartDate: openingShift.periodStartDate,
              periodEndDate: openingShift.periodEndDate,
              postingDate: openingShift.postingDate,
              status: openingShift.status,
              setPostingDate: openingShift.setPostingDate,
              doctype: openingShift.doctype,
              posProfile: openingShift.posProfile,
              balanceDetails: openingShift.balanceDetails,
            );

            await DbCreateShift().createShift(cashiers);
          }

          // FETCH BALANCE DETAILS LIST FROM POS OPENING SHIFT
          if (resp.message!.openingShiftBalance != null) {
            final balanceDetails = resp.message!.createOpeningShift!.balanceDetails.map((data) {
              // Map PaymentInfo to BalanceDetail
              final paymentInfo = balanceDetail.firstWhere((paymentInfo) => paymentInfo.paymentType == data.modeOfPayment);
              return BalanceDetail(
                modeOfPayment: paymentInfo.paymentType,
                amount: paymentInfo.amount, 
              );
            }).toList();

            await DbBalanceDetails().addBalanceDetails(balanceDetails);
          }

          return CommanResponse(
            status: true,
            message: SUCCESS,
            apiStatus: ApiStatus.REQUEST_SUCCESS,
          );
        } else {
          return CommanResponse(
            status: false,
            message: "No message data in the response",
            apiStatus: ApiStatus.FAILED,
          );
        }
      } catch (e) {
        print("Error occurred: $e");
        return CommanResponse(
          status: false,
          message: "An error occurred: $e",
          apiStatus: ApiStatus.FAILED,
        );
      }
    } else {
      return CommanResponse(
        status: false,
        message: NO_INTERNET,
        apiStatus: ApiStatus.NO_INTERNET,
      );
    }
  }
}
