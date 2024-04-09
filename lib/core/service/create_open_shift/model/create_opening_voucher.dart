import 'package:nb_posx/database/models/balance_details.dart';
import 'package:nb_posx/database/models/create_opening_shift.dart';

class CreateOpeningShiftResponse {
  final Message? message;

  CreateOpeningShiftResponse({this.message});

  factory CreateOpeningShiftResponse.fromJson(Map<String, dynamic> json) {
    return CreateOpeningShiftResponse(
      message: json['message'] != null
          ? Message.fromJson(json['message'] as Map<String, dynamic>)
          : null,
    );
  }
}

class Message {
  final CreateOpeningShiftDb? createOpeningShift;
  final List<BalanceDetail>? openingShiftBalance;

  Message({this.createOpeningShift, this.openingShiftBalance});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      createOpeningShift: json['pos_opening_shift'] != null
          ? CreateOpeningShiftDb.fromJson(
              json['pos_opening_shift'] as Map<String, dynamic>)
          : null,
      openingShiftBalance: (json['balance_details'] as List<dynamic>?)
          ?.map((detail) => BalanceDetail.fromJson(detail as Map<String, dynamic>))
          .toList(),
    );
  }
}
