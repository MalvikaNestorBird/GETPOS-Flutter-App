import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_posx/configs/theme_dynamic_colors.dart';
import 'package:nb_posx/constants/app_constants.dart';
import 'package:nb_posx/utils/ui_utils/spacer_widget.dart';
import 'package:nb_posx/utils/ui_utils/text_styles/custom_text_style.dart';
import 'package:nb_posx/widgets/button.dart';

class NewPopUpWidget extends StatefulWidget {
  const NewPopUpWidget({super.key});

  @override
  State<NewPopUpWidget> createState() => _NewPopUpWidgetState();
}

class _NewPopUpWidgetState extends State<NewPopUpWidget> {
  @override
  /// LOGIN BUTTON
  Widget get cancelBtnWidget => SizedBox(
        // width: double.infinity,
        child: ButtonWidget(
          onPressed: () => Get.back(),
          title: "Cancel",
          primaryColor: AppColors.getAsset(),
          width: 150,
          height: 50,
          fontSize: LARGE_PLUS_FONT_SIZE,
        ),
      );

Widget get confirmBtnWidget => SizedBox(
        // width: double.infinity,
        child: ButtonWidget(
          onPressed: () => 
                {
          //       // Close the current popup
          Navigator.pop(context),

          //   // Call the handleLogout function
          //   handleLogout();
         },
          title: "Confirm",
          primaryColor: AppColors.getPrimary(),
          width: 150,
          height: 50,
          fontSize: LARGE_PLUS_FONT_SIZE,
        ),
      );

  @override
  Widget build(BuildContext context) {
    // BuildContext? context = navigatorKey.currentContext;
    // if (context != null) {
    //   toast = ShowMToast(context);
    // }
    return SizedBox(
      width: 400,
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Please enter the payment methods",
              style: getTextStyle(fontSize: 28.0, fontWeight: FontWeight.bold)),
          hightSpacer10,
          // Text("Please open the shift first?",
          //     style: getTextStyle(
          //         fontSize: LARGE_FONT_SIZE, fontWeight: FontWeight.w500)),
          hightSpacer10,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [cancelBtnWidget, confirmBtnWidget],
          ),
        ],
      ),
    );
  }
}