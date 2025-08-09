

import '../../Models/collectionsModels.dart';

abstract class CollectionsState {}

class CollectionsInitial extends CollectionsState {}

class CollectionsLoading extends CollectionsState {}

class CollectionsLoaded extends CollectionsState {
  final CollectionsModel collections;
  final String selectedLanguage;
  final List<String> availableLanguages;
  final bool isLoadingLanguage;

  CollectionsLoaded({
    required this.collections,
    this.selectedLanguage = 'All',
    required this.availableLanguages,
    this.isLoadingLanguage = false,
  });

  CollectionsLoaded copyWith({
    CollectionsModel? collections,
    String? selectedLanguage,
    List<String>? availableLanguages,
    bool? isLoadingLanguage,

  }) {
    return CollectionsLoaded(
      collections: collections ?? this.collections,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      availableLanguages: availableLanguages ?? this.availableLanguages,
        isLoadingLanguage: isLoadingLanguage ?? this.isLoadingLanguage,
    );
  }
}

class CollectionsError extends CollectionsState {
  final String message;

  CollectionsError(this.message);
}