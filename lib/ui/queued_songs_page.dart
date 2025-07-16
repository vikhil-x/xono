import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers.dart';
import 'search_item.dart';

class QueuedSongsPage extends ConsumerWidget {
  const QueuedSongsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playlist = ref.watch(playlistProvider);

    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
      child: playlist.isEmpty
          ? ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) => const ShimmerTile(),
              physics: const BouncingScrollPhysics(),
            )
          : ListView.builder(
              itemCount: playlist.length,
              itemBuilder: (context, index) =>
                  SearchItemTile(song: playlist[index], resetQueue: false),
              physics: const BouncingScrollPhysics(),
            ),
    );
  }
}
