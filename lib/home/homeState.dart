import 'package:equatable/equatable.dart';

import '../Models/collectionsModels.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final CollectionsModel collections;

  const HomeLoaded({required this.collections});

  @override
  List<Object?> get props => [collections];
}

class HomeError extends HomeState {
  final String message;

  const HomeError({required this.message});

  @override
  List<Object?> get props => [message];
}