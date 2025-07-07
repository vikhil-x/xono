import 'package:dart_ytmusic_api/dart_ytmusic_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers.dart';
import '../core/yt_scrape.dart';
import 'package:shimmer/shimmer.dart';

class SearchItemTile extends ConsumerWidget {
  final SongDetailed song;

  const SearchItemTile({Key? super.key, required this.song});

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
        final scraper = await ref.read(ytScraperProvider.future);
        final uri = await scraper.getUri(song.videoId);
        await ref.read(playerControlProvider).play(uri);
      },
    );
  }
}

class ShimmerTile extends StatelessWidget {
  const ShimmerTile({Key? super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade800,
      highlightColor: Colors.grey.shade600,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.black,
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 16,
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.black,
              ),
            ),
            Container(
              height: 14,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.black,
              ),
            ),
          ],
        ),
        subtitle: null,
        trailing: Container(height: 14, width: 32),
      ),
    );
  }
}
