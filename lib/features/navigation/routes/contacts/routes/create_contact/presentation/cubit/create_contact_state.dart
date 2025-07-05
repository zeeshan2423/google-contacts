part of 'create_contact_cubit.dart';

sealed class CreateContactState extends Equatable {
  const CreateContactState();
}

final class CreateContactInitial extends CreateContactState {
  @override
  List<Object> get props => [];
}
