// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sale_order.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SaleOrderAdapter extends TypeAdapter<SaleOrder> {
  @override
  final int typeId = 11;

  @override
  SaleOrder read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SaleOrder(
      name: fields[0] as String,
      posOpeningShift: fields[1] as String,
      id: fields[2] as String,
      date: fields[3] as String,
      time: fields[4] as String,
      customer: fields[5] as Customer,
      manager: fields[6] as HubManager,
      items: (fields[7] as List).cast<OrderItem>(),
      orderAmount: fields[8] as double,
      transactionId: fields[9] as String,
      transactionSynced: fields[10] as bool,
      tracsactionDateTime: fields[11] as DateTime,
      paymentMethod: fields[12] == null ? '' : fields[12] as String,
      paymentStatus: fields[13] == null ? 'Unpaid' : fields[13] as String,
      parkOrderId: fields[14] as String?,
      taxes: (fields[15] as List?)?.cast<OrderTax>(),
    );
  }

  @override
  void write(BinaryWriter writer, SaleOrder obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.posOpeningShift)
      ..writeByte(2)
      ..write(obj.id)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.time)
      ..writeByte(5)
      ..write(obj.customer)
      ..writeByte(6)
      ..write(obj.manager)
      ..writeByte(7)
      ..write(obj.items)
      ..writeByte(8)
      ..write(obj.orderAmount)
      ..writeByte(9)
      ..write(obj.transactionId)
      ..writeByte(10)
      ..write(obj.transactionSynced)
      ..writeByte(11)
      ..write(obj.tracsactionDateTime)
      ..writeByte(12)
      ..write(obj.paymentMethod)
      ..writeByte(13)
      ..write(obj.paymentStatus)
      ..writeByte(14)
      ..write(obj.parkOrderId)
      ..writeByte(15)
      ..write(obj.taxes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SaleOrderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
