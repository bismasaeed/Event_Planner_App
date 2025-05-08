import 'package:flutter_bloc/flutter_bloc.dart';
import 'vendor_event.dart';
import 'vendor_state.dart';
import 'package:event_planner_app/repositories/vendor_repository.dart';

class VendorBloc extends Bloc<VendorEvent, VendorState> {
  final VendorRepository vendorRepository;

  VendorBloc(this.vendorRepository) : super(VendorInitial()) {
    on<SubmitVendorForm>((event, emit) async {
      emit(VendorSubmitting());
      try {
        await vendorRepository.uploadVendorData(
          category: event.category,
          name: event.name,
          contact: event.contact,
          price: event.price,
          quantity: event.quantity,
          extraField1: event.extraField1,
          extraField2: event.extraField2,
          imageFile: event.imageFile,
        );
        emit(VendorSubmissionSuccess());
      } catch (e) {
        emit(VendorSubmissionFailure(e.toString()));
      }
    });
  }
}
