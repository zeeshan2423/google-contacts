part of 'create_contact_cubit.dart';

sealed class CreateContactState extends Equatable {
  const CreateContactState();

  @override
  List<Object> get props => [];
}

final class CreateContactInitial extends CreateContactState {
  const CreateContactInitial();
}

final class CreateContactInProgress extends CreateContactState {
  const CreateContactInProgress();
}

final class CreateContactSuccess extends CreateContactState {
  const CreateContactSuccess();
}

final class EditContactSuccess extends CreateContactState {
  const EditContactSuccess();
}

final class CreateContactFailure extends CreateContactState {
  const CreateContactFailure(this.message);

  final String message;

  @override
  List<String> get props => [message];
}
