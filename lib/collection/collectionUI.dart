
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Models/collectionsModels.dart';
import 'collectionCubit.dart';
import 'collectionState.dart';

class CollectionPage extends StatelessWidget {
  const CollectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CollectionsCubit()..fetchCollections(),
      child: const CollectionView(),
    );
  }
}

class CollectionView extends StatelessWidget {
  const CollectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CollectionsCubit, CollectionsState>(
      builder: (context, state) {
        if (state is CollectionsLoading || state is CollectionsInitial) {
          return Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              backgroundColor: Colors.black,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
              ),
              title: const Text(
                'Collections',
                style: TextStyle(color: Colors.white),
              ),
            ),
            body: const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF9575CD),
              ),
            ),
          );
        }

        if (state is CollectionsError) {
          return Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              backgroundColor: Colors.black,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
              ),
              title: const Text(
                'Collections',
                style: TextStyle(color: Colors.white),
              ),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${state.message}',
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<CollectionsCubit>().fetchCollections();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF9575CD),
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        if (state is CollectionsLoaded) {
          final tabs = state.availableLanguages;

          return DefaultTabController(
            length: tabs.length,
            child: Scaffold(
              backgroundColor: Colors.black,
              appBar: AppBar(
                backgroundColor: Colors.black,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                ),
                title: const Text(
                  'Collections',
                  style: TextStyle(color: Colors.white),
                ),
                bottom: tabs.length > 1
                    ? TabBar(
                  isScrollable: true,
                  indicatorColor: const Color(0xFF9575CD),
                  indicatorWeight: 3,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey,
                  onTap: (index) {
                    context.read<CollectionsCubit>().changeLanguage(tabs[index]);
                  },
                  tabs: tabs.map((tab) => Tab(text: tab)).toList(),
                )
                    : null,
                actions: [
                  IconButton(
                    icon: Stack(
                      children: [
                        const Icon(Icons.notifications_outlined, color: Colors.white, size: 28),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 8),
                  const CircleAvatar(
                    backgroundColor: Colors.grey,
                    radius: 18,
                    child: Icon(Icons.person, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 16),
                ],
              ),
              body: tabs.length > 1
                  ? TabBarView(
                children: tabs.map((tab) {
                  return BlocBuilder<CollectionsCubit, CollectionsState>(
                    builder: (context, state) {
                      if (state is CollectionsLoaded) {

                        if (state.selectedLanguage != tab) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            context.read<CollectionsCubit>().changeLanguage(tab);
                          });
                        }

                        final movies = context.read<CollectionsCubit>().getFilteredMovies(state);

                        if (movies.isEmpty) {
                          return Center(
                            child: Text(
                              'No movies found for $tab',
                              style: const TextStyle(color: Colors.white),
                            ),
                          );
                        }

                        return AllCollectionPage(movies: movies);
                      }
                      return const SizedBox.shrink();
                    },
                  );
                }).toList(),
              )
                  : BlocBuilder<CollectionsCubit, CollectionsState>(
                builder: (context, state) {
                  if (state is CollectionsLoaded) {
                    final movies = context.read<CollectionsCubit>().getFilteredMovies(state);

                    if (movies.isEmpty) {
                      return const Center(
                        child: Text(
                          'No movies found',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }

                    return AllCollectionPage(movies: movies);
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

class AllCollectionPage extends StatelessWidget {
  final List<BannerMovie> movies;

  const AllCollectionPage({super.key, required this.movies});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final smallBoxWidth = (screenWidth - 40) / 3;
    final bigBoxWidth = screenWidth * 0.6;
    final smallColumnBoxWidth = screenWidth - bigBoxWidth - 30;

    final List<Widget> rows = [];
    int index = 0;
    int rowCount = 0;

    while (index + 2 < movies.length) {
      if (rowCount % 4 == 0) {
        // Pattern B - Big left, two small right
        rows.add(RowPatternB(
          bigMovie: movies[index],
          small1: movies[index + 1],
          small2: movies[index + 2],
          bigWidth: bigBoxWidth,
          smallWidth: smallColumnBoxWidth,
        ));
      } else if (rowCount % 2 == 1) {
        // Pattern A - Three equal boxes
        rows.add(RowPatternA(
          movies: movies.sublist(index, index + 3),
          width: smallBoxWidth,
        ));
      } else {
        // Pattern C - Two small left, big right
        rows.add(RowPatternC(
          small1: movies[index],
          small2: movies[index + 1],
          bigMovie: movies[index + 2],
          bigWidth: bigBoxWidth,
          smallWidth: smallColumnBoxWidth,
        ));
      }

      rowCount++;
      index += 3;
    }

    // Handle remaining movies
    final remaining = movies.length - index;
    if (remaining == 1) {
      rows.add(Center(
        child: MovieBox(
          movie: movies[index],
          width: screenWidth - 20,
          height: 200,
        ),
      ));
    } else if (remaining == 2) {
      rows.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          MovieBox(
            movie: movies[index],
            width: (screenWidth - 30) / 2,
            height: 180,
          ),
          MovieBox(
            movie: movies[index + 1],
            width: (screenWidth - 30) / 2,
            height: 180,
          ),
        ],
      ));
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView.separated(
        padding: const EdgeInsets.all(10),
        itemCount: rows.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, i) => rows[i],
      ),
    );
  }
}

class RowPatternA extends StatelessWidget {
  final List<BannerMovie> movies;
  final double width;

  const RowPatternA({required this.movies, required this.width, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: movies.map((movie) {
        return MovieBox(
          movie: movie,
          width: width,
          height: 150,
        );
      }).toList(),
    );
  }
}

class RowPatternB extends StatelessWidget {
  final BannerMovie bigMovie, small1, small2;
  final double bigWidth, smallWidth;

  const RowPatternB({
    required this.bigMovie,
    required this.small1,
    required this.small2,
    required this.bigWidth,
    required this.smallWidth,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MovieBox(
          movie: bigMovie,
          width: bigWidth,
          height: 310,
          margin: const EdgeInsets.only(right: 10),
        ),
        Column(
          children: [
            MovieBox(
              movie: small1,
              width: smallWidth,
              height: 150,
              margin: const EdgeInsets.only(bottom: 10),
            ),
            MovieBox(
              movie: small2,
              width: smallWidth,
              height: 150,
            ),
          ],
        ),
      ],
    );
  }
}

class RowPatternC extends StatelessWidget {
  final BannerMovie small1, small2, bigMovie;
  final double bigWidth, smallWidth;

  const RowPatternC({
    required this.small1,
    required this.small2,
    required this.bigMovie,
    required this.bigWidth,
    required this.smallWidth,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            MovieBox(
              movie: small1,
              width: smallWidth,
              height: 150,
              margin: const EdgeInsets.only(bottom: 10, right: 10),
            ),
            MovieBox(
              movie: small2,
              width: smallWidth,
              height: 150,
              margin: const EdgeInsets.only(right: 10),
            ),
          ],
        ),
        MovieBox(
          movie: bigMovie,
          width: bigWidth,
          height: 310,
        ),
      ],
    );
  }
}

class MovieBox extends StatelessWidget {
  final BannerMovie movie;
  final double width;
  final double height;
  final EdgeInsetsGeometry? margin;

  const MovieBox({
    required this.movie,
    required this.width,
    required this.height,
    this.margin,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to movie details
        print('Tapped on: ${movie.name}');
      },
      child: Container(
        width: width,
        height: height,
        margin: margin,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey[800],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: movie.poster ?? movie.thumbnail ?? '',
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey[800],
                  child: const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Color(0xFF9575CD),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[800],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.movie, color: Colors.grey, size: 40),
                      const SizedBox(height: 8),
                      Text(
                        movie.name ?? 'Movie',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Gradient overlay for better text visibility
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.8),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}