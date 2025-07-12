import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers.dart';
import 'search_item.dart';

class QueuedSongsPage extends ConsumerWidget {
  const QueuedSongsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final relatedSongsAsync = ref.watch(relatedSongsProvider);

    return Padding(
        padding: const EdgeInsets.only(top: 8),
        child: relatedSongsAsync.when(
          loading: () => ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) => const ShimmerTile(),
            physics: const BouncingScrollPhysics(),
          ),
          error: (error, _) => Center(child: Text('Could not load songs')),
          data: (queue) => ListView.builder(
            itemCount: queue.length,
            itemBuilder: (context, index) =>
                SearchItemTile(song: queue[index]),
            physics: const BouncingScrollPhysics(),
          ),
        ),
    );
  }
}

