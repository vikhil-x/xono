import 'package:dart_ytmusic_api/dart_ytmusic_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers.dart';
export 'search_item_shimmer.dart';

class SearchItemTile extends ConsumerWidget {
  final SongDetailed song;

  const SearchItemTile({super.key, required this.song});

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
      //trailing: Text((song.duration ?? '').toString()),
      title: Text(song.name, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(
        song.artist.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      onTap: () async {
        ref.read(currentlyPlayingProvider.notifier).state = song;
        final scraper = await ref.read(ytScraperProvider.future);
        final uri = await scraper.getUri(song.videoId);
        await ref.read(playerControlProvider).play(uri);
      },
    );
  }
}

