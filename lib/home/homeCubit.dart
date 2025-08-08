import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../Models/collectionsModels.dart';
import '../network/collectionAPI.dart';
import 'homeState.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  Future<void> fetchCollections() async {
    emit(HomeLoading());
    try {
      final collections = await CollectionsService.fetchCollections();
      emit(HomeLoaded(collections: collections!));
    } catch (e) {
      emit(HomeError(message: 'Error fetching collections: $e'));
    }
  }

  void refresh() {
    fetchCollections();
  }
}