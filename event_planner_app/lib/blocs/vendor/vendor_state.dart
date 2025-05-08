import 'package:equatable/equatable.dart';

abstract class VendorState extends Equatable {
  const VendorState();

  @override
  List<Object?> get props => [];
}

class VendorInitial extends VendorState {}

class VendorSubmitting extends VendorState {}

class VendorSubmissionSuccess extends VendorState {}

class VendorSubmissionFailure extends VendorState {
  final String error;

  const VendorSubmissionFailure(this.error);

  @override
  List<Object?> get props => [error];
}
