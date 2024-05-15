// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales_order_req.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SalesOrderRequestAdapter extends TypeAdapter<SalesOrderRequest> {
  @override
  final int typeId = 23;

  @override
  SalesOrderRequest read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SalesOrderRequest(
      name: fields[0] as String?,
      posOpeningShift: fields[1] as String?,
      hubManager: fields[9] as String?,
      customer: fields[2] as String?,
      transactionDate: fields[3] as String?,
      deliveryDate: fields[4] as String?,
      items: (fields[5] as List?)?.cast<SaleOrderRequestItems>(),
      modeOfPayment: fields[6] as String?,
      mpesaNo: fields[7] as String?,
      tax: (fields[8] as List?)?.cast<OrderTax>(),
    );
  }

  @override
  void write(BinaryWriter writer, SalesOrderRequest obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.posOpeningShift)
      ..writeByte(2)
      ..write(obj.customer)
      ..writeByte(3)
      ..write(obj.transactionDate)
      ..writeByte(4)
      ..write(obj.deliveryDate)
      ..writeByte(5)
      ..write(obj.items)
      ..writeByte(6)
      ..write(obj.modeOfPayment)
      ..writeByte(7)
      ..write(obj.mpesaNo)
      ..writeByte(8)
      ..write(obj.tax)
      ..writeByte(9)
      ..write(obj.hubManager);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SalesOrderRequestAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
