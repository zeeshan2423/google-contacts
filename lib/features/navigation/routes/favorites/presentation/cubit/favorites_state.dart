part of 'favorites_cubit.dart';

sealed class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object> get props => [];
}

final class FavoritesInitial extends FavoritesState {
  const FavoritesInitial();
}

final class FavoritesInProgress extends FavoritesState {
  const FavoritesInProgress();
}

final class FavoritesSuccess extends FavoritesState {
  const FavoritesSuccess(this.favorites);

  final List<Contact> favorites;

  @override
  List<Contact> get props => favorites;
}

final class FavoritesFailure extends FavoritesState {
  const FavoritesFailure(this.message);

  final String message;

  @override
  List<String> get props => [message];
}
