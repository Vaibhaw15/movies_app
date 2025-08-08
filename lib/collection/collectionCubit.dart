import 'package:flutter_bloc/flutter_bloc.dart';

import '../Models/collectionsModels.dart';
import '../network/collectionAPI.dart';
import 'collectionState.dart';

class CollectionsCubit extends Cubit<CollectionsState> {
  CollectionsCubit() : super(CollectionsInitial());

  Future<void> fetchCollections() async {
    emit(CollectionsLoading());

    try {
      final collections = await _fetchCollectionsFromApi();
      if (collections != null) {
        final languages = _extractLanguages(collections);
        emit(CollectionsLoaded(
          collections: collections,
          availableLanguages: languages,
        ));
      } else {
        emit(CollectionsError('Failed to load collections'));
      }
    } catch (e) {
      emit(CollectionsError(e.toString()));
    }
  }

  List<String> _extractLanguages(CollectionsModel collections) {
    final languageSet = <String>{'All'};
    final allMovies = <BannerMovie>[];


    allMovies.addAll(collections.data?.latestReleases ?? []);
    allMovies.addAll(collections.data?.featuredMovies ?? []);
    allMovies.addAll(collections.data?.topPickWeek ?? []);
    allMovies.addAll(collections.data?.recommendationMovies ?? []);
    allMovies.addAll(collections.data?.payPerView ?? []);
    allMovies.addAll(collections.data?.buy ?? []);

    // Add genre movies
    collections.data?.genre?.lifeUfiction?.forEach((movie) {
      allMovies.add(movie);
    });

    collections.data?.genre?.aiFilmFest?.forEach((movie) {
      allMovies.add(movie);
    });

    // Add festival movies
    collections.data?.festival?.aiFilmFestRound1?.forEach((movie) {
      allMovies.add(movie);
    });

    // Extract unique languages
    for (var movie in allMovies) {
      for (var language in movie.language) {
        if (language.name != null && language.name!.isNotEmpty) {
          languageSet.add(language.name!);
        }
      }
    }

    // Convert to list and sort (keeping 'All' first)
    final languages = languageSet.toList();
    languages.sort((a, b) {
      if (a == 'All') return -1;
      if (b == 'All') return 1;
      return a.compareTo(b);
    });

    return languages;
  }

  void changeLanguage(String language) {
    if (state is CollectionsLoaded) {
      final currentState = state as CollectionsLoaded;
      emit(currentState.copyWith(selectedLanguage: language));
    }
  }

  Future<CollectionsModel?> _fetchCollectionsFromApi() async {
    try {
      final collections = await CollectionsService.fetchCollections();
      return collections;
    } catch (e) {
      print('Error fetching collections: $e');
      return null;
    }
  }

  List<BannerMovie> getFilteredMovies(CollectionsLoaded state) {
    final allMovies = <BannerMovie>[];

    // Combine all movies from different sections
    allMovies.addAll(state.collections.data?.latestReleases ?? []);
    allMovies.addAll(state.collections.data?.featuredMovies ?? []);
    allMovies.addAll(state.collections.data?.topPickWeek ?? []);
    allMovies.addAll(state.collections.data?.recommendationMovies ?? []);
    allMovies.addAll(state.collections.data?.payPerView ?? []);
    allMovies.addAll(state.collections.data?.buy ?? []);

    // Add genre movies
    state.collections.data?.genre?.lifeUfiction?.forEach((movie) {
      if (!allMovies.any((m) => m.id == movie.id)) {
        allMovies.add(movie);
      }
    });

    state.collections.data?.genre?.aiFilmFest?.forEach((movie) {
      if (!allMovies.any((m) => m.id == movie.id)) {
        allMovies.add(movie);
      }
    });

    // Add festival movies
    state.collections.data?.festival?.aiFilmFestRound1?.forEach((movie) {
      if (!allMovies.any((m) => m.id == movie.id)) {
        allMovies.add(movie);
      }
    });

    // Filter by language if not "All"
    if (state.selectedLanguage != 'All') {
      return allMovies.where((movie) {
        return movie.language.any((lang) =>
        lang.name?.toLowerCase() == state.selectedLanguage.toLowerCase()
        );
      }).toList();
    }

    return allMovies;
  }
}