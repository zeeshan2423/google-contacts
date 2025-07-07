part of 'favorites_cubit.dart';

sealed class FavoritesState extends Equatable {
  const FavoritesState();
}

final class FavoritesInitial extends FavoritesState {
  @override
  List<Object> get props => [];
}
