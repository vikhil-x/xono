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
    final playlist = ref.watch(playlistProvider);

    void onSelectionChanged(Set<bool> selection) async {
      setState(() {
        queueType = selection;
      });
      await ref.read(playerControlProvider).enqueueSongs(artist: selection.first);
    }

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
            child: playlist.isEmpty
                ? ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) => const ShimmerTile(),
              physics: const BouncingScrollPhysics(),
            )
                : ListView.builder(
              itemCount: playlist.length,
              itemBuilder: (context, index) => SearchItemTile(
                  song: playlist[index], resetQueue: false),
              physics: const BouncingScrollPhysics(),
            ),
          ),
        ],
      ),
    );
  }
}


