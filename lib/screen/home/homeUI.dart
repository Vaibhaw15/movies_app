import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Models/collectionsModels.dart';
import '../../util/logo.dart';
import 'homeCubit.dart';
import 'homeState.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().fetchCollections();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leadingWidth: 0,
        leading: const SizedBox(),
        // title: Padding(
        //   padding: const EdgeInsets.only(left: 16),
        //   child: Image.asset('assets/images/logo.png', scale: 20),
        // ),
        title: ImboxoLogo(width: 14,height: 22,small: true,),
        actions: const [
          Icon(Icons.notifications_outlined, size: 28, color: Colors.white),
          SizedBox(width: 16),
          const CircleAvatar(
            backgroundColor: Colors.grey,
            radius: 18,
            child: Icon(Icons.person, color: Colors.white, size: 20),
          ),
          SizedBox(width: 16),
        ],
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.red),
            );
          }

          if (state is HomeError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 60),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      state.message,
                      style: const TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<HomeCubit>().fetchCollections();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: const Text('Retry', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            );
          }

          if (state is HomeLoaded) {
            final data = state.collections.data;

            if (data == null) {
              return const Center(
                child: Text(
                  'No data available',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () => context.read<HomeCubit>().fetchCollections(),
              backgroundColor: Colors.black87,
              color: Colors.red,
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 10),
                children: [
                  // Banner Section
                  if (data.bannerMovie != null)
                    _buildBannerSection(data.bannerMovie!),

                  const SizedBox(height: 20),

                  // Latest Releases
                  if (data.latestReleases.isNotEmpty) ...[
                    _sectionTitle('Latest Releases'),
                    const SizedBox(height: 10),
                    _buildMovieList(data.latestReleases, isVertical: true),
                    const SizedBox(height: 20),
                  ],

                  // Trending Now (Using Featured Movies since trending is empty)
                  if (data.featuredMovies.isNotEmpty) ...[
                    _sectionTitle('Trending Now'),
                    const SizedBox(height: 10),
                    _buildHorizontalMovieList(data.featuredMovies),
                    const SizedBox(height: 20),
                  ],

                  // Life Fiction Movies (from Genre)
                  if (data.genre?.lifeUfiction != null &&
                      data.genre!.lifeUfiction.isNotEmpty) ...[
                    _sectionTitle('Life Fiction Movies'),
                    const SizedBox(height: 10),
                    _buildCircularMovieList(data.genre!.lifeUfiction),
                    const SizedBox(height: 20),
                  ],

                  // AI Film Fest
                  if (data.genre?.aiFilmFest != null &&
                      data.genre!.aiFilmFest.isNotEmpty) ...[
                    _sectionTitle('AI Film Fest'),
                    const SizedBox(height: 10),
                    _buildMovieList(data.genre!.aiFilmFest, isVertical: true),
                    const SizedBox(height: 20),
                  ],

                  // Festival - AI Film Fest Round 1
                  if (data.festival?.aiFilmFestRound1 != null &&
                      data.festival!.aiFilmFestRound1.isNotEmpty) ...[
                    _sectionTitle('AI Film Fest Round 1'),
                    const SizedBox(height: 10),
                    _buildHorizontalMovieList(data.festival!.aiFilmFestRound1),
                    const SizedBox(height: 20),
                  ],

                  // Top Picks This Week
                  if (data.topPickWeek.isNotEmpty) ...[
                    _sectionTitle('Top Picks This Week'),
                    const SizedBox(height: 10),
                    _buildMovieList(data.topPickWeek, isVertical: true),
                    const SizedBox(height: 20),
                  ],

                  // Recommendations
                  if (data.recommendationMovies.isNotEmpty) ...[
                    _sectionTitle('Recommended For You'),
                    const SizedBox(height: 10),
                    _buildHorizontalMovieList(data.recommendationMovies),
                    const SizedBox(height: 20),
                  ],

                  // Pay Per View
                  if (data.payPerView.isNotEmpty) ...[
                    _sectionTitle('Pay Per View'),
                    const SizedBox(height: 10),
                    _buildMovieList(data.payPerView, isVertical: true),
                    const SizedBox(height: 20),
                  ],

                  // Buy Movies
                  if (data.buy.isNotEmpty) ...[
                    _sectionTitle('Buy Movies'),
                    const SizedBox(height: 10),
                    _buildMovieList(data.buy, isVertical: true),
                    const SizedBox(height: 20),
                  ],
                ],
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildBannerSection(BannerMovie movie) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: CachedNetworkImage(
              imageUrl: movie.poster ?? movie.thumbnail ?? '',
              height: 220,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                height: 220,
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.red, strokeWidth: 2),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                height: 220,
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.error, color: Colors.red),
              ),
            ),
          ),
          Container(
            height: 220,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.7),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    label: const Text(
                      'Watch Now',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMovieList(List<BannerMovie> movies, {bool isVertical = true}) {
    return SizedBox(
      height: 220,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: movies.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final movie = movies[index];
          return InkWell(
            onTap: () {
              // Handle movie tap
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedNetworkImage(
                        imageUrl: movie.thumbnail ?? movie.poster ?? '',
                        width: 140,
                        height: isVertical ? 180 : 120,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          width: 140,
                          height: isVertical ? 180 : 120,
                          decoration: BoxDecoration(
                            color: Colors.grey[900],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: Colors.red,
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          width: 140,
                          height: isVertical ? 180 : 120,
                          decoration: BoxDecoration(
                            color: Colors.grey[900],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.movie, color: Colors.grey),
                        ),
                      ),
                    ),
                    if (movie.favorite == true)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.favorite,
                            color: Colors.red,
                            size: 16,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: 140,
                  child: Text(
                    movie.name ?? 'Unknown Title',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHorizontalMovieList(List<BannerMovie> movies) {
    return SizedBox(
      height: 160,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: movies.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final movie = movies[index];
          return InkWell(
            onTap: () {
              // Handle movie tap
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedNetworkImage(
                        imageUrl: movie.thumbnail ?? movie.poster ?? '',
                        width: 200,
                        height: 120,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          width: 200,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.grey[900],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: Colors.red,
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          width: 200,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.grey[900],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.movie, color: Colors.grey),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: 200,
                  child: Text(
                    movie.name ?? 'Unknown Title',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCircularMovieList(List<BannerMovie> movies) {
    return SizedBox(
      height: 160,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: movies.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final movie = movies[index];
          return InkWell(
            onTap: () {
              // Handle movie tap
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 2,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: CachedNetworkImage(
                          imageUrl: movie.thumbnail ?? movie.poster ?? '',
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.grey[900],
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: Colors.red,
                                strokeWidth: 2,
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.grey[900],
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.movie, color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: 100,
                  child: Text(
                    movie.name ?? 'Unknown Title',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          InkWell(
            onTap: () {

            },
            child: Row(
              children: const [
                Icon(Icons.arrow_forward_ios, size: 14, color: Colors.white),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
