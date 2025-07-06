import 'package:google_contacts/core/constants/imports.dart';

class ToggleFavorite extends UseCaseWithParams<void, ToggleFavoriteParams> {
  const ToggleFavorite(this._repository);

  final ContactDetailRepository _repository;

  @override
  ResultVoid<void> call(ToggleFavoriteParams params) async =>
      _repository.toggleFavorite(id: params.id);
}

class ToggleFavoriteParams extends Equatable {
  const ToggleFavoriteParams({required this.id});

  final String id;

  @override
  List<Object?> get props => [id];
}
