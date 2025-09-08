import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers.dart';
import 'search_item.dart';

class QueuedSongsPage extends ConsumerStatefulWidget {
  const QueuedSongsPage({super.key});

  @override
  ConsumerState<QueuedSongsPage> createState() => _QueuedSongsPageState();
}

class _QueuedSongsPageState extends ConsumerState<QueuedSongsPage> {
  Set<bool> queueType = {false};

  @override
  Widget build(BuildContext context) {
    final currentSongAsync = ref.watch(currentSongProvider);

    void onSelectionChanged(Set<bool> selection) {
      setState(() {
        queueType = selection;
      });
    }

    return currentSongAsync.maybeWhen(
      data: (song) {
        if (song == null) {
          return const SizedBox.shrink();
        }

        final playlistAsync = ref.watch(
          playlistProvider((song, queueType.first)),
        );

        return Padding(
          padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
          child: Column(
            children: [
              SegmentedButton<bool>(
                showSelectedIcon: false,
                segments: const [
                  ButtonSegment(
                    value: true,
                    label: Text('By Artist'),
                    icon: Icon(Icons.person),
                  ),
                  ButtonSegment(
                    value: false,
                    label: Text('By Album'),
                    icon: Icon(Icons.album_sharp),
                  ),
                ],
                selected: queueType,
                onSelectionChanged: onSelectionChanged,
              ),
              Expanded(
                child: playlistAsync.when(
                  loading: () => ListView.builder(
                    itemCount: 10,
                    itemBuilder: (context, index) => const ShimmerTile(),
                    physics: const BouncingScrollPhysics(),
                  ),
                  error: (err, stack) => Center(
                    child: Text('Error: $err'),
                  ),
                  data: (playlist) => ListView.builder(
                    itemCount: playlist.length,
                    itemBuilder: (context, index) => SearchItemTile(
                      song: playlist[index],
                      resetQueue: false,
                    ),
                    physics: const BouncingScrollPhysics(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}
