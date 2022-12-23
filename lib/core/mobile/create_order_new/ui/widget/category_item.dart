import 'dart:developer';

import '../../../../../configs/theme_config.dart';
import '../../../../../constants/app_constants.dart';
import '../../../../../constants/asset_paths.dart';
import '../../../../../database/models/product.dart';
import '../../../../../utils/helper.dart';
import '../../../../../utils/ui_utils/card_border_shape.dart';
import '../../../../../utils/ui_utils/padding_margin.dart';
import '../../../../../utils/ui_utils/spacer_widget.dart';
import '../../../../../utils/ui_utils/text_styles/custom_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

// ignore: must_be_immutable
class CategoryItem extends StatefulWidget {
  Product? product;

  CategoryItem({Key? key, this.product}) : super(key: key);

  @override
  State<CategoryItem> createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> {
  bool isUserOnline = true;

  @override
  void initState() {
    _checkUserAvailability();
    super.initState();
  }

  _checkUserAvailability() async {
    isUserOnline = await Helper.isNetworkAvailable();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: cardBorderShape(),
        margin: mediumPaddingAll(),
        child: Container(
          padding: horizontalSpace(),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Expanded(
              flex: 2,
              child: Container(
                  decoration: BoxDecoration(
                      // border: Border.all(
                      //   color: GREY_COLOR,
                      // ),
                      borderRadius: BorderRadius.circular(20)),
                  padding: verticalSpace(),
                  child: _getOrderedProductImage()),
            ),
            widthSpacer(10),
            Expanded(
              flex: 4,
              child: Container(
                height: 85,
                padding: verticalSpace(x: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.product!.name,
                      style: getTextStyle(
                          fontSize: MEDIUM_PLUS_FONT_SIZE,
                          fontWeight: FontWeight.normal),
                    ),
                    Text(
                      '$ITEM_CODE_TXT - ${widget.product!.id}',
                      style: getTextStyle(
                          fontWeight: FontWeight.normal,
                          color: DARK_GREY_COLOR),
                    ),
                    const Spacer(),
                    Text(
                      '$APP_CURRENCY ${widget.product!.price}',
                      style: getTextStyle(
                          fontSize: SMALL_PLUS_FONT_SIZE,
                          color: MAIN_COLOR,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            )
          ]),
        ));
  }

  _getOrderedProductImage() {
    if (isUserOnline && widget.product!.productImageUrl!.isNotEmpty) {
      log('Image Url : ${widget.product!.productImageUrl!}');
      return ClipRRect(
          borderRadius: BorderRadius.circular(8), // Image border
          child: SizedBox(
            // Image radius
            height: 80,
            child: Image(image: NetworkImage(widget.product!.productImageUrl!)),
          ));
    } else {
      log('Local image');
      return widget.product!.productImage.isEmpty
          ? SvgPicture.asset(
              PRODUCT_IMAGE_,
              height: 30,
              width: 30,
              fit: BoxFit.contain,
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(8), // Image border
              child: SizedBox(
                // Image radius
                height: 80,
                child: Image.memory(widget.product!.productImage,
                    fit: BoxFit.cover),
              ),
            );
      // Image.memory(widget.product!.productImage);
    }
  }
}
