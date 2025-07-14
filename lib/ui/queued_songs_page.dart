import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers.dart';
import 'search_item.dart';

class QueuedSongsPage extends ConsumerWidget {
  const QueuedSongsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSongAsync = ref.watch(currentSongProvider);

    return currentSongAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Error loading current song')),
      data: (currentSong) {
        if (currentSong == null) {
          return const Center(child: Text('No song currently playing.'));
        }

        final relatedSongsAsync = ref.watch(relatedSongsProvider(currentSong));

        return Padding(
          padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
          child: relatedSongsAsync.when(
            loading: () => ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) => const ShimmerTile(),
              physics: const BouncingScrollPhysics(),
            ),
            error: (error, _) => const Center(child: Text('Could not load related songs')),
            data: (queue) => ListView.builder(
              itemCount: queue.length,
              itemBuilder: (context, index) =>
                  SearchItemTile(song: queue[index], resetQueue: false),
              physics: const BouncingScrollPhysics(),
            ),
          ),
        );
      },
    );
  }
}
