import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:nb_posx/database/db_utils/db_constants.dart';
import 'package:nb_posx/database/models/shift_management.dart';


class DbShiftManagement {
  late Box box;

  Future<void> saveShiftManagementData(ShiftManagement shiftManagement) async {
    // Open the Hive box
    var box = await Hive.openBox<ShiftManagement>(SHIFT_MANAGEMENT_BOX);

    // Save the shift management data
    await box.put(SHIFT_ID,shiftManagement);

    // Close the Hive box
   //await box.close();
  }

Future<void> closeShiftManagement(ShiftManagement shiftManagement) async {
    // Open the Hive box
    var box = await Hive.openBox<ShiftManagement>(SHIFT_MANAGEMENT_BOX);

    // Save the shift management data
    await box.put(SHIFT_ID, shiftManagement);

    // Close the Hive box
    await box.close();
  }

Future<int> deleteShift() async {
    box = await Hive.openBox<ShiftManagement>(SHIFT_MANAGEMENT_BOX);
    return box.clear();
  }

// fetch the data saved against pos profile for closing the shift
// Future<ShiftManagement> getShiftManagementData() async {
//   var box = await Hive.openBox(SHIFT_MANAGEMENT_BOX);
//   log('HIVE BOX: $box');

//   var shiftData = box.get(SHIFT_ID);
//   log('SHIFT DATA TYPE: ${shiftData.runtimeType}');
//   log('SHIFT DATA VALUE: $shiftData');

//   await box.close();

//   if (shiftData is Map<dynamic, dynamic>) {
//     // Extract shift management data
//     if (shiftData.containsKey(SHIFT_ID)) {
//       return Future.value(shiftData[SHIFT_ID]);
//     } else {
//       throw Exception('Shift management data not found');
//     }
//   } else {
//     throw Exception('Invalid data type returned from Shift Management data');
//   }
// }

Future<ShiftManagement> getShiftManagement() async {
  var box = await Hive.openBox<ShiftManagement>(SHIFT_MANAGEMENT_BOX);
  var shiftData = box.get(SHIFT_ID);
  return shiftData!;
}


}



