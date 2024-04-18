import 'package:hive/hive.dart';
import 'package:nb_posx/database/db_utils/db_constants.dart';
import 'package:nb_posx/database/models/payment_info.dart';

class DbPaymentInfo {
  late Box box;


  Future<void> saveBalanceDetails(List<PaymentInfo> paymentInfoList) async {
  final box = await Hive.openBox<PaymentInfo>(PAYMENT_INFO_BOX);
  await box.clear(); // Clear existing data
  await box.addAll(paymentInfoList);
}

Future<List<PaymentInfo>> getBalanceDetail() async {
  final box = await Hive.openBox<PaymentInfo>(PAYMENT_INFO_BOX);
  return box.values.toList();
}

Future<void> delete() async {
    box = await Hive.openBox<PaymentInfo>(PAYMENT_INFO_BOX);
    await box.clear();
    await box.close();
  }
}