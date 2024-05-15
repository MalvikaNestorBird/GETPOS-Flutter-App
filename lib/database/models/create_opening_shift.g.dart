// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_opening_shift.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CreateOpeningShiftDbAdapter extends TypeAdapter<CreateOpeningShiftDb> {
  @override
  final int typeId = 28;

  @override
  CreateOpeningShiftDb read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CreateOpeningShiftDb(
      name: fields[1] as String,
      periodStartDate: fields[2] as DateTime,
      periodEndDate: fields[3] as DateTime?,
      status: fields[4] as String,
      postingDate: fields[5] as DateTime?,
      setPostingDate: fields[6] as int,
      company: fields[7] as String,
      posProfile: fields[8] as String,
      doctype: fields[9] as String,
      balanceDetails: (fields[10] as List).cast<BalanceDetail>(),
    );
  }

  @override
  void write(BinaryWriter writer, CreateOpeningShiftDb obj) {
    writer
      ..writeByte(10)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.periodStartDate)
      ..writeByte(3)
      ..write(obj.periodEndDate)
      ..writeByte(4)
      ..write(obj.status)
      ..writeByte(5)
      ..write(obj.postingDate)
      ..writeByte(6)
      ..write(obj.setPostingDate)
      ..writeByte(7)
      ..write(obj.company)
      ..writeByte(8)
      ..write(obj.posProfile)
      ..writeByte(9)
      ..write(obj.doctype)
      ..writeByte(10)
      ..write(obj.balanceDetails);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreateOpeningShiftDbAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
