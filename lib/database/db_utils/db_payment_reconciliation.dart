import 'package:hive/hive.dart';
import 'package:nb_posx/database/db_utils/db_constants.dart';
import 'package:nb_posx/database/models/payment_reconciliation.dart';

class DbPaymentReconciliation {
  late Box box;


  Future<void> saveBalanceDetails(List<PaymentReconciliation> paymentrReconciliationList) async {
  final box = await Hive.openBox<PaymentReconciliation>(PAYMENT_RECONCILIATION_BOX);
  await box.clear(); // Clear existing data
  await box.addAll(paymentrReconciliationList);
}

Future<PaymentReconciliation?> getBalanceDetail() async {
  final box = await Hive.openBox<PaymentReconciliation>(PAYMENT_RECONCILIATION_BOX);
  var shiftData = box.get(PAYMENT_ID);
  await box.close();
  return shiftData;
}


}