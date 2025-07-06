part of 'contact_detail_cubit.dart';

sealed class ContactDetailState extends Equatable {
  const ContactDetailState();

  @override
  List<Object> get props => [];
}

final class ContactDetailInitial extends ContactDetailState {
  const ContactDetailInitial();
}

final class ContactDetailInProgress extends ContactDetailState {
  const ContactDetailInProgress();
}

final class ContactDetailSuccess extends ContactDetailState {
  const ContactDetailSuccess();
}

final class ContactDeleteSuccess extends ContactDetailState {
  const ContactDeleteSuccess();
}

final class ContactDetailFailure extends ContactDetailState {
  const ContactDetailFailure(this.message);

  final String message;

  @override
  List<String> get props => [message];
}
