import 'package:dart_ytmusic_api/dart_ytmusic_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xono/ui/visualizer.dart';
import '../providers.dart';
export 'search_item_shimmer.dart';

class SearchItemTile extends ConsumerWidget {
  final SongDetailed song;
  final bool resetQueue;

  const SearchItemTile({
    super.key,
    required this.song,
    required this.resetQueue,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
            image: NetworkImage(song.thumbnails[0].url),
            fit: BoxFit.cover,
          ),
        ),
      ),
      trailing:
          ref.watch(currentSongProvider).asData?.value?.videoId == song.videoId
          ? SizedBox(width: 30, height: 20, child: MusicVisualizer())
          : null,
      title: Text(song.name, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(
        song.artist.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      onTap: () async {
        await ref.read(playerControlProvider).play(song, resetQueue);
      },
    );
  }
}
