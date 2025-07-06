part of 'contacts_cubit.dart';

sealed class ContactsState extends Equatable {
  const ContactsState();

  @override
  List<Object> get props => [];
}

final class ContactsInitial extends ContactsState {
  const ContactsInitial();
}

final class ContactsInProgress extends ContactsState {
  const ContactsInProgress();
}

final class ContactsSuccess extends ContactsState {
  const ContactsSuccess(this.contacts);

  final List<Contact> contacts;

  @override
  List<Contact> get props => contacts;
}

final class ContactsFailure extends ContactsState {
  const ContactsFailure(this.message);

  final String message;

  @override
  List<String> get props => [message];
}
