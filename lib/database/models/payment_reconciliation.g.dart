// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_reconciliation.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PaymentReconciliationAdapter extends TypeAdapter<PaymentReconciliation> {
  @override
  final int typeId = 31;

  @override
  PaymentReconciliation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PaymentReconciliation(
      modeOfPayment: fields[1] as String,
      openingAmount: fields[2] as double,
      closingAmount: fields[3] as double,
      expectedAmount: fields[4] as double,
      difference: fields[5] as double,
    );
  }

  @override
  void write(BinaryWriter writer, PaymentReconciliation obj) {
    writer
      ..writeByte(5)
      ..writeByte(1)
      ..write(obj.modeOfPayment)
      ..writeByte(2)
      ..write(obj.openingAmount)
      ..writeByte(3)
      ..write(obj.closingAmount)
      ..writeByte(4)
      ..write(obj.expectedAmount)
      ..writeByte(5)
      ..write(obj.difference);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaymentReconciliationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
