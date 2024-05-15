import 'dart:developer';
import 'dart:math' as _min;
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:nb_posx/configs/theme_dynamic_colors.dart';
import 'package:nb_posx/constants/app_constants.dart';
import 'package:nb_posx/core/service/make_close_shift/service/make_close_shift_api.dart';
import 'package:nb_posx/core/tablet/home_tablet.dart';
import 'package:nb_posx/database/db_utils/db_constants.dart';
import 'package:nb_posx/database/db_utils/db_instance_url.dart';
import 'package:nb_posx/database/db_utils/db_payment_info.dart';
import 'package:nb_posx/database/db_utils/db_payment_reconciliation.dart';
import 'package:nb_posx/database/db_utils/db_payment_types.dart';
import 'package:nb_posx/database/db_utils/db_preferences.dart';
import 'package:nb_posx/database/db_utils/db_shift_management.dart';
import 'package:nb_posx/database/models/payment_info.dart';
import 'package:nb_posx/database/models/payment_reconciliation.dart';
import 'package:nb_posx/database/models/payment_type.dart';
import 'package:nb_posx/database/models/shift_management.dart';
import 'package:nb_posx/network/api_constants/api_paths.dart';
import 'package:nb_posx/network/api_helper/comman_response.dart';
import 'package:nb_posx/utils/helper.dart';
import 'package:nb_posx/utils/ui_utils/padding_margin.dart';
import 'package:nb_posx/utils/ui_utils/spacer_widget.dart';
import 'package:nb_posx/widgets/button.dart';

import '../../../network/service/api_utils.dart';

class CloseShiftManagement extends StatefulWidget {
  final bool isShiftOpen;
  final RxString selectedView;
  const CloseShiftManagement(
      {Key? key, this.isShiftOpen = true, required this.selectedView})
      : super(key: key);

  @override
  CloseShiftManagementState createState() => CloseShiftManagementState();
}

class CloseShiftManagementState extends State<CloseShiftManagement> {
  bool isShiftOpen = false;
//late List<TextEditingController> controllers;
  Map<String, TextEditingController> controllersMap = {};
  ShiftManagement? closeShiftManagement;
  List<PaymentReconciliation>? paymentReconciliationList;
  late Future<ShiftManagement?> _future;
  Future<ShiftManagement>? shiftManagementFuture;
  ShiftManagement? submitPaymentDetails;
  List<PaymentType> paymentMethods = [];
  PaymentReconciliation? paymentDetail;
  String selectedPosProfile = "";
  List<ShiftManagement>? shiftManagementList;
  bool isEmptyController = false;

  @override
  void initState() {
    // Call fetchClosingShift in initState
    super.initState();
    // controllers = [];
    controllersMap = {};
    _future = fetchClosingShift();
    //loadPaymentMethods();
  }

  @override
  void dispose() {
    // for (var controller in controllers) {
    //   controller.dispose(); // Dispose all text editing controllers
    // }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.fontWhiteColor,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width / 3,
            padding: paddingXY(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                hightSpacer10,
                closeShiftHeadingWidget(),
                hightSpacer120,
                hightSpacer30,
                fetchOpeningShiftData(_future),
                hightSpacer30,
                closeShiftBtnWidget(_future),
                hightSpacer30,
              ],
            ),
          ),
        ),
      ),
    );
  }

//Close Shift Heading
  Widget closeShiftHeadingWidget() => Center(
        child: Text(
          CLOSE_SHIFT.toUpperCase(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: LARGE_PLUS_FONT_SIZE,
          ),
        ),
      );

  //FETCH THE DATA FROM OPENING SHIFT
  Widget fetchOpeningShiftData(shiftManagementFuture) =>
      FutureBuilder<ShiftManagement?>(
        future: _future,
        builder: (context, snapshot) {
          // builder:  (BuildContext context, AsyncSnapshot<ShiftManagement?> snapshot){
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError || snapshot.data == null) {
            return const Text('No data available');
          } else {
            var shiftManagement = snapshot.data!;
            //  snapshot.data?.paymentReconciliation.forEach((element)){controllers.add(TextEditingController())};
            return paymentMethodsWidget(shiftManagement);
          }
        },
      );

// Payment methods widget
  Widget paymentMethodsWidget(ShiftManagement shiftManagement) {
    var details = DbShiftManagement().getShiftManagement();
    log("Details :: $details");
    if (shiftManagement.paymentReconciliation == null ||
        shiftManagement.paymentReconciliation!.isEmpty) {
      return const Text('No payment methods available');
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: shiftManagement.paymentReconciliation!.length,
      itemBuilder: (context, index) {
        final paymentReconciliation =
            shiftManagement.paymentReconciliation![index];
        // Get mode of payment
        final modeOfPayment = paymentReconciliation.modeOfPayment;

        // Initialize or get existing controller for this mode of payment
        TextEditingController controller =
            controllersMap.containsKey(modeOfPayment)
                ? controllersMap[modeOfPayment]!
                : TextEditingController();

        // Store the controller in the map
        controllersMap[modeOfPayment] = controller;

        // Initialize new TextEditingController for each item
        //List< TextEditingController> controllers = [];

        // Add the controller to the list
        //  controllers.add(TextEditingController());

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 60,
              width: 500,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.getshadowBorder()),
                borderRadius: BorderRadius.circular(6.0),
              ),
              child: Padding(
                padding: leftSpace(x: 10),
                child: Center(
                  child: TextFormField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintStyle: TextStyle(
                        color: AppColors.asset,
                        fontWeight: FontWeight.w500,
                      ),
                      contentPadding: leftSpace(x: 21),
                      border: InputBorder.none,
                      hintText:
                          'Enter the closing ${paymentReconciliation.modeOfPayment} balance',
                    ),
                  ),
                ),
              ),
            ),
            hightSpacer5,
            Text(
              'System Closing ${paymentReconciliation.modeOfPayment} Balance: ${paymentReconciliation.openingAmount}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            hightSpacer30,
          ],
        );
      },
    );
  }

//Button for Close Shift and clear the DB after closing the shift

  Widget closeShiftBtnWidget(Future<ShiftManagement?> shiftManagementFuture) =>
      ButtonWidget(
        colorTxt: AppColors.fontWhiteColor,
        isMarginRequired: false,
        width: 600,
        onPressed: () async {
            for (TextEditingController controller in controllersMap.values) {
                if (controller.text.isEmpty) {
                  isEmptyController = true;
                  break;
                }
                else {
              isEmptyController = false;
            }
              }
           if(!isEmptyController){

          ShiftManagement? submitPaymentDetails = await shiftManagementFuture;

// Initialize paymentReconciliationList if it's null
          paymentReconciliationList ??= [];

// Iterate through controllersMap to create PaymentReconciliation objects
          for (var modeOfPayment in controllersMap.keys) {
            TextEditingController controller = controllersMap[modeOfPayment]!;
            double closingAmount = double.tryParse(controller.text) ?? 0.0;

            // Find the corresponding PaymentReconciliation object for the current modeOfPayment
            PaymentReconciliation? paymentReconciliation;
            for (var reconciliation
                in submitPaymentDetails!.paymentReconciliation!) {
              if (reconciliation.modeOfPayment == modeOfPayment) {
                paymentReconciliation = reconciliation;
                break;
              }
            }

            // Use null-aware operator to get openingAmount, defaulting to 0 if paymentReconciliation is null
            double openingAmount = paymentReconciliation?.openingAmount ?? 0.0;
            double expectedAmount =
                paymentReconciliation?.expectedAmount ?? 0.0;

            // Create PaymentReconciliation object using the fetched amounts
            PaymentReconciliation paymentReconcile = PaymentReconciliation(
              modeOfPayment: modeOfPayment,
              closingAmount: closingAmount,
              openingAmount: openingAmount,
              expectedAmount: expectedAmount,
            );
            paymentReconciliationList!.add(paymentReconcile);
          }

          ShiftManagement shiftManagement = ShiftManagement(
            periodStartDate: submitPaymentDetails!.periodStartDate,
            periodEndDate: submitPaymentDetails.periodEndDate,
            postingDate: submitPaymentDetails.postingDate,
            posOpeningShift: submitPaymentDetails.posOpeningShift,
            posProfile: submitPaymentDetails.posProfile,
            doctype: submitPaymentDetails.doctype,
            paymentsMethod: paymentMethods,
            paymentReconciliation: paymentReconciliationList,
          );
          log('Shift Info: $shiftManagement');

          // Save the shift management data before navigating to HomeTablet
          await DbShiftManagement().saveShiftManagementData(shiftManagement);

          //submit shift api call
          await submitShift(shiftManagement);

          //If Shift gets synced in ERP clear the DB of close shift
          await DbShiftManagement().deleteShift();
          // await DbPaymentTypes().delete();
           //await DbPaymentInfo().delete();
        }
         else if(isEmptyController) {
            Helper.showPopup(context, "Please enter the payment amount");
          }
         },

        title: CLOSE_SHIFT.toUpperCase(),
        primaryColor: AppColors.getPrimary(),
        height: 60,
        fontSize: LARGE_FONT_SIZE,
      );

  Future<void> submitShift(ShiftManagement shiftManagementFuture) async {
    try {
      // Calculate expected amount for each payment reconciliation
      if (shiftManagementFuture != null) {
        for (int i = 0;
            i < shiftManagementFuture.paymentReconciliation!.length;
            i++) {
          // Ensure payment reconciliation and payment info list have the same length
          if (i < shiftManagementFuture.paymentReconciliation!.length) {
            shiftManagementFuture.paymentReconciliation![i].difference =
                shiftManagementFuture.paymentReconciliation![i].closingAmount -
                    shiftManagementFuture
                        .paymentReconciliation![i].expectedAmount;
          } else {
            print(
                'Error: Payment info list is shorter than payment reconciliation list');
          }
        }
      }

      // Print the difference
      for (var reconciliation in shiftManagementFuture.paymentReconciliation!) {
        log('Difference: ${reconciliation.difference}');
      }

      submitPaymentDetails = ShiftManagement(
          periodStartDate: shiftManagementFuture.periodStartDate,
          periodEndDate: shiftManagementFuture.periodEndDate,
          postingDate: shiftManagementFuture.postingDate,
          posOpeningShift: shiftManagementFuture.posOpeningShift,
          posProfile: shiftManagementFuture.posProfile,
          doctype: shiftManagementFuture.doctype,
          paymentReconciliation: shiftManagementFuture.paymentReconciliation,
          company: shiftManagementFuture.company);

      Map<String, dynamic> body = fetchOpeningShiftToMap(submitPaymentDetails!);

      String apiUrl = SUBMIT_CLOSING_SHIFT;

      final response = await APIUtils.postRequest(apiUrl, body);

      if (response['message'] != null) {
        log('Response of Submit Shift Api::$response');
        // Navigate to HomeTablet
        // ignore: use_build_context_synchronously
        await Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeTablet(isShiftCreated: false),
          ),
        );
        if (!mounted) return;
        Helper.hideLoader(context);
      } else {
        log('API Request failed with status code $response');
        log('Response body: $response');
        log('Dbinstance Url:');
      }
    } catch (e) {
      // Handle any exceptions during the request
      log('Error: $e');
    }
  }

  Future<ShiftManagement> fetchClosingShift() async {
    try {
      // Helper.showLoaderDialog(context);
      // api theme path get and append
      CommanResponse response =
          await ClosingShiftService.fetchClosingShiftData();
      log('$response');

      if (response.status != null && response.status!) {
        // ignore: use_build_context_synchronously
        // Helper.hideLoader(context);

        log("Response: ${response.status}");

        if (mounted) {
          return response.message;
          // _future = await response.message as Future<ShiftManagement>;
        }
      } else {
        if (mounted) {
          //  Helper.hideLoader(context);
          Helper.showPopup(context, response.message);
        }
      }
    } catch (e) {
      if (mounted) {
        // Helper.hideLoader(context);
        log('Exception Caught :: $e');
        debugPrintStack();
        Helper.showSnackBar(context, SOMETHING_WRONG);
      }
    }
    return ShiftManagement(paymentReconciliation: paymentReconciliationList);
  }

  static Map<String, dynamic> fetchOpeningShiftToMap(
      ShiftManagement closingShift) {
    // Function to format DateTime objects to string with "T" replaced by space
    String formatDate(DateTime dateTime) {
      return dateTime.toIso8601String().replaceAll('T', ' ');
    }

    Map<String, dynamic> shiftMap = {
      'period_start_date': formatDate(closingShift.periodStartDate!),
      'posting_date': closingShift.postingDate != null
          ? formatDate(closingShift.postingDate!)
          : null,
      'pos_profile': closingShift.posProfile,
      'pos_opening_shift': closingShift.posOpeningShift,
      'doctype': closingShift.doctype,
      'payment_reconciliation': closingShift.paymentReconciliation!
          .map((detail) => detail.toJson())
          .toList(),
    };

    // Check if periodEndDate is not null before adding it to the map
    if (closingShift.periodEndDate != null) {
      shiftMap['period_end_date'] =
          formatDate(closingShift.periodEndDate!); // Convert DateTime to string
    }

    return {"closing_shift": shiftMap};
  }
}
