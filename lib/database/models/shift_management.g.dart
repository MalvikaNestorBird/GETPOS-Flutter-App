// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shift_management.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ShiftManagementAdapter extends TypeAdapter<ShiftManagement> {
  @override
  final int typeId = 27;

  @override
  ShiftManagement read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ShiftManagement(
      periodStartDate: fields[0] as DateTime?,
      periodEndDate: fields[1] as DateTime?,
      postingDate: fields[2] as DateTime?,
      posOpeningShift: fields[3] as String?,
      company: fields[4] as String?,
      posProfile: fields[5] as String?,
      doctype: fields[6] as String?,
      paymentsMethod: (fields[7] as List?)?.cast<PaymentType>(),
      paymentInfoList: (fields[8] as List?)?.cast<PaymentInfo>(),
      paymentReconciliation:
          (fields[9] as List?)?.cast<PaymentReconciliation>(),
    );
  }

  @override
  void write(BinaryWriter writer, ShiftManagement obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.periodStartDate)
      ..writeByte(1)
      ..write(obj.periodEndDate)
      ..writeByte(2)
      ..write(obj.postingDate)
      ..writeByte(3)
      ..write(obj.posOpeningShift)
      ..writeByte(4)
      ..write(obj.company)
      ..writeByte(5)
      ..write(obj.posProfile)
      ..writeByte(6)
      ..write(obj.doctype)
      ..writeByte(7)
      ..write(obj.paymentsMethod)
      ..writeByte(8)
      ..write(obj.paymentInfoList)
      ..writeByte(9)
      ..write(obj.paymentReconciliation);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShiftManagementAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
