import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:nb_posx/database/db_utils/db_constants.dart';
import '../models/pos_profile_cashier.dart';
///
///DB FOR STORE THE POS PROFILE CASHIER LOCALLY
///
class DbPosProfileCashier {
  late Box box;
  ///
  /// ADD THE POS PROFILES
  ///
  Future<void> addPosProfileCashiers(List<PosProfileCashier> list) async {
    box = await Hive.openBox<PosProfileCashier>(POS_PROFILE_CASHIER);

    for (PosProfileCashier cashier in list) {
      await box.put(cashier.name, cashier);
    }
  }
  ///
  ///RETRIVE OR FETCH THE POS CASHIER
  ///
  Future<List<PosProfileCashier>> getPosProfileCashiers() async {
    box = await Hive.openBox<PosProfileCashier>(POS_PROFILE_CASHIER);

    List<PosProfileCashier> list = [];
    for (var cashier in box.values) {
      var posCustomer = cashier as PosProfileCashier;
      list.add(posCustomer);
    }
    return list;
  }

  ///
  ///RETRIVE THE CASHIER SORTED BY NAME
  ///
  Future<List<PosProfileCashier>> getPosProfileCashierSortedByName() async {
    box = await Hive.openBox<PosProfileCashier>(POS_PROFILE_CASHIER);
    List<PosProfileCashier> list = box.values.toList().cast();
    list.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return list;
  }

///
///FILTER THE POS CASHIER WITH THE COMPANY
///
Future<String?> getCompanyByProfileName(String selectedProfile) async {
  box = await Hive.openBox<PosProfileCashier>(POS_PROFILE_CASHIER);
  List<PosProfileCashier> posProfiles = [];

  box.values.where((profile) => profile.name == selectedProfile).forEach((profile) {
    log('Values:$profile');
    posProfiles.add(profile);
  });

  log('LIST:$posProfiles');

  if (posProfiles.isNotEmpty) {
   //provided that a posprofile can have one company only
    return posProfiles.first.company;
  } else {
    // Return null if no matching profile is found
    return null;
  }
}

  ///
  ///DELETE ALL THE POS CASHIER IN THE DB
  ///
  Future<int> deleteAllPosProfileCashier() async {
    box = await Hive.openBox<PosProfileCashier>(POS_PROFILE_CASHIER);
    return await box.clear();
  }

  ///
  ///DELETE THE POS CASHIER OF A PARTICULAR KEY VALUE 
  ///
  Future<bool> deletePosProfileCashier(String key) async {
    box = await Hive.openBox<PosProfileCashier>(POS_PROFILE_CASHIER);
    PosProfileCashier? posCashier = box.get(key);
    if (posCashier != null) posCashier.delete();
    return true;
  }
}
