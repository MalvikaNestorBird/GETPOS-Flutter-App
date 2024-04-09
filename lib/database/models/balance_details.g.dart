// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'balance_details.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BalanceDetailAdapter extends TypeAdapter<BalanceDetail> {
  @override
  final int typeId = 29;

  @override
  BalanceDetail read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BalanceDetail(
      modeOfPayment: fields[10] as String,
      amount: fields[11] as double,
    );
  }

  @override
  void write(BinaryWriter writer, BalanceDetail obj) {
    writer
      ..writeByte(2)
      ..writeByte(10)
      ..write(obj.modeOfPayment)
      ..writeByte(11)
      ..write(obj.amount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BalanceDetailAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
