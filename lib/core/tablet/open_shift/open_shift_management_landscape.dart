import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
// for json decoding
import 'package:nb_posx/configs/theme_dynamic_colors.dart';
import 'package:nb_posx/constants/app_constants.dart';
import 'package:nb_posx/constants/asset_paths.dart';
import 'package:nb_posx/core/service/create_open_shift/service/create_opening_shift_api.dart';
import 'package:nb_posx/core/tablet/home_tablet.dart';
import 'package:nb_posx/core/tablet/widget/new_show_popup_widget.dart';
import 'package:nb_posx/database/db_utils/db_constants.dart';
import 'package:nb_posx/database/db_utils/db_payment_info.dart';
import 'package:nb_posx/database/db_utils/db_payment_types.dart';
import 'package:nb_posx/database/db_utils/db_pos_profile_cashier.dart';
import 'package:nb_posx/database/db_utils/db_preferences.dart';
import 'package:nb_posx/database/db_utils/db_shift_management.dart';
import 'package:nb_posx/database/models/payment_info.dart';
import 'package:nb_posx/database/models/payment_type.dart';
import 'package:nb_posx/database/models/pos_profile_cashier.dart';
import 'package:nb_posx/database/models/shift_management.dart';
import 'package:nb_posx/network/api_helper/comman_response.dart';
import 'package:nb_posx/utils/helper.dart';
import 'package:nb_posx/utils/ui_utils/padding_margin.dart';
import 'package:nb_posx/utils/ui_utils/spacer_widget.dart';
import 'package:nb_posx/utils/ui_utils/text_styles/custom_text_style.dart';
import 'package:nb_posx/widgets/button.dart';

class OpenShiftManagement extends StatefulWidget {
  final bool isShiftCreated;
  final RxString? selectedView;
  final void Function(bool) updateShiftStatus;
  const OpenShiftManagement({
    Key? key,
    this.isShiftCreated = false,
    this.selectedView,
    required this.updateShiftStatus,
  }) : super(key: key);

  @override
  State<OpenShiftManagement> createState() => _OpenShiftManagementState();
}

class _OpenShiftManagementState extends State<OpenShiftManagement> {
  bool isShiftCreated = false;
  List<PosProfileCashier> posProfiles = [];
  List<PaymentType> paymentMethods = [];
  String selectedPosProfile = "";
  late List<TextEditingController> controllers;
   bool isEmptyController = false;

  @override
  void initState() {
    super.initState();
    controllers = [];

    fetchPOSProfileData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
                openShiftHeadingWidget(),
                hightSpacer120,
                hightSpacer30,
                posCashierSection(),
                hightSpacer30,
                numericTextFields(),
                hightSpacer10,
                openShiftBtnWidget(),
                hightSpacer30,
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Heading for Open Shift
  Widget openShiftHeadingWidget() => Center(
        child: Text(
          OPEN_SHIFT.toUpperCase(),
          style: getTextStyle(
            fontWeight: FontWeight.bold,
            fontSize: LARGE_PLUS_FONT_SIZE,
          ),
        ),
      );

//Select Pos Profile Cashier through DropDown
  Widget posCashierSection() {
    return FutureBuilder<List<PosProfileCashier>>(
      future: DbPosProfileCashier().getPosProfileCashierSortedByName(),
      builder: (context, snapshot) {
        // if (snapshot.connectionState == ConnectionState.waiting) {
        //   return const CircularProgressIndicator();
        // }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<PosProfileCashier>? posProfiles = snapshot.data;
          return ListView(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            children: [
              Container(
                height: 60,
                width: 480,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.getshadowBorder()),
                  borderRadius: BorderRadius.circular(6.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      icon: Padding(
                        padding: smallPaddingAll(),
                        child: SvgPicture.asset(
                          DROPDOWN_ICON,
                          color: AppColors.textandCancelIcon,
                          width: 20,
                        ),
                      ),
                      borderRadius: BorderRadius.circular(6.0),
                      menuMaxHeight: 250,
                      value: selectedPosProfile.isEmpty
                          ? null
                          : selectedPosProfile,
                      hint: Center(
                        child: Padding(
                          padding: leftSpace(x: 10),
                          child: Text(
                            SELECT_POS_PROFILE,
                            style: TextStyle(
                                fontSize: LARGE_FONT_SIZE,
                                color: AppColors.asset,
                                fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      items: posProfiles?.map((profile) {
                            return DropdownMenuItem<String>(
                              value: profile.name,
                              child: Padding(
                                padding: leftSpace(x: 16),
                                child: Text(
                                  profile.name,
                                  style: TextStyle(
                                      color: AppColors.textandCancelIcon),
                                ),
                              ),
                            );
                          }).toList() ??
                          [],
                      onChanged: (value) {
                       // setState(() {
                          selectedPosProfile = value!;
                          loadPaymentMethods(selectedPosProfile);
                          DBPreferences().savePreference(SELECTED_POS_PROFILE_ID, selectedPosProfile);
                       // });
                      },
                    ),
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }

//Fetch Payment Methods from DB for the selected POS Profile
  void loadPaymentMethods(String selectedProfile) {
    DbPaymentTypes().getPaymentMethodsbyParent(selectedProfile).then((methods) {
      setState(() {
        paymentMethods = methods ?? [];
        controllers = List.generate(
            paymentMethods.length, (index) => TextEditingController());
      });
    });
  }

//Dynamic Text Fields for Entering balance in Payment Methods
  Widget numericTextFields() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: paymentMethods.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            Container(
              height: 60,
              width: 500,
              decoration: BoxDecoration(
                  border: Border.all(color: AppColors.getshadowBorder()),
                  borderRadius: BorderRadius.circular(6.0)),
              child: Center(
                child: Padding(
                  padding: leftSpace(x: 10),
                  child: TextFormField(
                    controller: controllers[index],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      contentPadding: leftSpace(x: 21),
                      border: InputBorder.none,
                      hintTextDirection: TextDirection.ltr,
                      hintStyle: TextStyle(color: AppColors.asset),
                      hintText:
                          'Enter the opening ${paymentMethods[index].modeOfPayment} balance',
                    ),
                  ),
                ),
              ),
            ),
            hightSpacer30,
          ],
        );
      },
    );
  }

  //Button for Open Shift and passing the data in DB through createShiftManagement
  Widget openShiftBtnWidget() => ButtonWidget(
        colorTxt: AppColors.fontWhiteColor,
        isMarginRequired: false,
        width: 600,
        onPressed: () async {
          for (TextEditingController controller in controllers) {
            if (controller.text.isEmpty) {
              isEmptyController = true;
              break;
            } else {
              isEmptyController = false;
            }
          }

          if (selectedPosProfile.isEmpty) {
            Helper.showPopup(context, "Please select the POS Profile");
          } 
        else if (!isEmptyController) {
            if (selectedPosProfile.isNotEmpty && paymentMethods.isNotEmpty) {
              // List<double> amounts = controllers.map((controller) => controller.text).cast<double>().toList();
              List<double> amounts = [];
              for (var text
                  in controllers.map((controller) => controller.text)) {
                try {
                  double amount = double.parse(text);
                  amounts.add(amount);
                } catch (e) {
                  // Handle the error, such as logging it or skipping the invalid entry.
                  print("Error parsing amount: $e");
                }
              }
              // Create a list of PaymentInfo objects
              List<PaymentInfo> paymentInfoList = [];
              for (int i = 0; i < paymentMethods.length; i++) {
                PaymentInfo paymentInfo = PaymentInfo(
                  paymentType: paymentMethods[i].modeOfPayment,
                  amount: amounts[i],
                );
                paymentInfoList.add(paymentInfo);
              }
              await DbPaymentInfo().saveBalanceDetails(paymentInfoList);

              ShiftManagement shiftManagement = ShiftManagement(
                posProfile: selectedPosProfile,
                paymentsMethod: paymentMethods,
                paymentInfoList: paymentInfoList,
              );
              log('Shift Info: $shiftManagement');

// Save the shift management data before navigating to HomeTablet
              await DbShiftManagement()
                  .saveShiftManagementData(shiftManagement);
            }
            // Update the shift state
            setState(() {
              isShiftCreated = true;
            });
            await createOpeningShift(selectedPosProfile);
          } 
          else if(isEmptyController) {
            Helper.showPopup(context, "Please enter the payment amount");
          }

          //LeftSideMenu(isShiftCreated: true,selectedView:RxString(widget.selectedView!.value,));
       },
        title: OPEN_SHIFT.toUpperCase(),
        primaryColor: AppColors.getPrimary(),
        height: 60,
        fontSize: LARGE_FONT_SIZE,
      );

//To Fetch the POS Profiles Sorted by Name
  Future<void> fetchPOSProfileData() async {
    try {
      // Fetch POS profile cashiers from the local database
      List<PosProfileCashier> cashiers =
          await DbPosProfileCashier().getPosProfileCashierSortedByName();

      // Update the posProfiles list with fetched data
      setState(() {
        posProfiles = cashiers;
      });
    } catch (e) {
      print('Error fetching POS profile data from local database: $e');
    }
  }

  Future<void> createOpeningShift(selectedPosProfile) async {
    try {
      Helper.showLoaderDialog(context);
      //api theme path get and append
      CommanResponse response = await CreateOpeningShiftService()
          .createOpeningShiftDetails(selectedPosProfile);
      log('$response');

      if (response.status != null && response.status!) {
        // ignore: use_build_context_synchronously
        Helper.hideLoader(context);

        log("response :: $response");

        //Navigate to HOME SCREEN
        // ignore: use_build_context_synchronously
        await Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeTablet(
              isShiftCreated: true,
            ),
          ),
        );
      } else {
        if (!mounted) return;
        Helper.hideLoader(context);
        Helper.showPopup(context, response.message);
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      Helper.hideLoader(context);
      log('Exception Caught :: $e');

      debugPrintStack();
      // ignore: use_build_context_synchronously
      Helper.showSnackBar(context, SOMETHING_WRONG);
    }
  }
}
