import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class VendorEvent extends Equatable {
  const VendorEvent();

  @override
  List<Object?> get props => [];
}

class SubmitVendorForm extends VendorEvent {
  final String category;
  final String name;
  final String contact;
  final String price;
  final String quantity;
  final String extraField1;
  final String extraField2;
  final File imageFile;

  const SubmitVendorForm({
    required this.category,
    required this.name,
    required this.contact,
    required this.price,
    required this.quantity,
    required this.extraField1,
    required this.extraField2,
    required this.imageFile,
  });

  @override
  List<Object?> get props =>
      [category, name, contact, price, quantity, extraField1, extraField2, imageFile];
}
