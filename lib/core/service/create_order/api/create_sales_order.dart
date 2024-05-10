import 'dart:convert';
import 'dart:developer';

import 'package:intl/intl.dart';
import 'package:nb_posx/core/service/create_order/model/selected_options.dart'
    as request_sales;
import 'package:nb_posx/database/db_utils/db_constants.dart';
import 'package:nb_posx/database/db_utils/db_create_opening_shift.dart';
import 'package:nb_posx/database/db_utils/db_preferences.dart';
import 'package:nb_posx/database/models/sales_order_req.dart';

//import 'package:nb_posx/database/models/sales_order_req_items.dart';
import '../../../../../constants/app_constants.dart';
//import '../model/sales_order_request.dart' as request_sales;
//import '../model/sales_order_request.dart' as request_sales;
import '../../../../../database/db_utils/db_parked_order.dart';
import '../../../../../database/models/order_item.dart';
import '../../../../../database/models/sale_order.dart';
import '../../../../../network/api_constants/api_paths.dart';
import '../../../../../network/api_helper/api_status.dart';
import '../../../../../network/api_helper/comman_response.dart';
import '../../../../../network/service/api_utils.dart';
import '../../../../../utils/helper.dart';
import '../../../../../utils/helpers/sync_helper.dart';
import '../../../../database/models/sales_order_req_items.dart'
    as request_sales;
import '../model/create_sales_order_response.dart';

class CreateOrderService {
  
  Future<CommanResponse> createOrder(SaleOrder order) async {
    String posProfileId = "";
    if (await Helper.isNetworkAvailable()) {
      List<request_sales.SaleOrderRequestItems> items = [];
      for (OrderItem item in order.items) {
        List<request_sales.SelectedOptions> selectedOption = [];
        for (var atrib in item.attributes) {
          for (var opt in atrib.options) {
            if (opt.selected) {
              selectedOption.add(request_sales.SelectedOptions(
                id: opt.id,
                name: opt.name,
                price: opt.price,
                qty: item.orderedQuantity,
              ));
            }
          }
        }

        request_sales.SaleOrderRequestItems i =
            request_sales.SaleOrderRequestItems(
                itemCode: item.id,
                name: item.name,
                price: item.price,
                selectedOption: selectedOption,
                orderedPrice: item.orderedPrice,
                orderedQuantity: item.orderedQuantity,
                tax: item.tax);
        items.add(i);
      }

      var transactionDateTime =
          DateFormat('yyyy-MM-dd HH:mm:ss').format(order.tracsactionDateTime);
      log('Formatted Transaction Date Time :: $transactionDateTime');

      // //fetch pos cashier id
      // var posProfileId = await DbCreateShift().getOpeningShiftData();
      // log("POS Profile Id: $posProfileId");


var posProfileId = await DbCreateShift().getOpeningShiftData();
log("POS Profile Id: $posProfileId");

// Check if posProfileId is not null, then assign its name, otherwise assign an empty string
var posProfileName = posProfileId != null ? posProfileId.name : "";

      //fetch pos profile
      var selectedPosProfile = await DBPreferences().getPreference(SELECTED_POS_PROFILE_ID);

      //SALES ORDER REQUEST BODY 
      SalesOrderRequest orderRequest = SalesOrderRequest(
        name: selectedPosProfile,
        posOpeningShift: posProfileName,
        hubManager: order.manager.emailId,
        // ward: "order.customer.ward.id",
        customer: order.customer.id,
        transactionDate: transactionDateTime,
        deliveryDate: _parseDate(order.tracsactionDateTime),
        items: items,
        modeOfPayment: order.paymentMethod,
        mpesaNo: order.transactionId,
        tax: order.taxes,
      );

      var body = {'order_list': orderRequest.toMap()};

      log("$orderRequest");
      log(json.encode(body));

//log(jsonEncode(body, toEncodable: (dynamic nonEncodable) => nonEncodable.toString()));

      var apiResponse =
          await APIUtils.postRequest(CREATE_SALES_ORDER_PATH, body);

      log(json.encode(apiResponse));

      CreateSalesOrderResponse salesOrderResponse =
          CreateSalesOrderResponse.fromJson(apiResponse);
      SyncHelper().getDetails();

      // ignore: unnecessary_null_comparison
      if (salesOrderResponse.message != null &&
          salesOrderResponse.message.successKey == 1) {
        DbParkedOrder().deleteOrderById(order.parkOrderId!);
        return CommanResponse(
            status: true,
            message: salesOrderResponse.message.salesOrder.name,
            apiStatus: ApiStatus.REQUEST_SUCCESS);
      } else {
        return CommanResponse(
            status: false,
            message: SOMETHING_WRONG,
            apiStatus: ApiStatus.REQUEST_FAILURE);
      }
    } else {
      return CommanResponse(
          status: false,
          message: NO_INTERNET_CREATE_ORDER_SYNC_QUEUED,
          apiStatus: ApiStatus.NO_INTERNET);
    }
  }

  String _parseDate(DateTime date) {
    var month = date.month < 10 ? "0${date.month}" : date.month;
    var day = date.day < 10 ? "0${date.day}" : date.day;
    var dateValue = '${date.year}-$month-$day';

    log('Parsed date :: $dateValue');
    return dateValue;
  }

  // String _parseDateAndTime
}
