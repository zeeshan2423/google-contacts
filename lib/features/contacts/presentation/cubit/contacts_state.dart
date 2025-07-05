part of 'contacts_cubit.dart';

sealed class ContactsState extends Equatable {
  const ContactsState();
}

final class ContactsInitial extends ContactsState {
  @override
  List<Object> get props => [];
}
