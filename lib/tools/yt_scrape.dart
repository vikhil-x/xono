import 'package:dart_ytmusic_api/dart_ytmusic_api.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class Scraper {
  late YoutubeExplode explode;
  late YTMusic ytMusic;

  initialize() async {
    explode = YoutubeExplode();
    ytMusic = YTMusic();
    await ytMusic.initialize();
  }

  Future<Uri> getUri(String videoId) async {
    final manifest = await explode.videos.streamsClient.getManifest(videoId);
    final url = manifest.audioOnly.withHighestBitrate().url;
    return url;
  }

  Future<List<SongDetailed>> searchSongs(String query) async {
    final searchResults = await ytMusic.searchSongs(query);
    return searchResults;
  }

  Future<List<SongDetailed>> getRelatedSongs(SongDetailed song) async {
    final data = await ytMusic.constructRequest("next", body: {"videoId": song.videoId});
    //Navigating deeply through youtube JSON request
    final items = traverseList(data, [
      "contents",
      "singleColumnMusicWatchNextResultsRenderer",
      "tabbedRenderer",
      "watchNextTabbedResultsRenderer",
      "tabs",
      "0",
      "tabRenderer",
      "content",
      "musicQueueRenderer",
      "content",
      "playlistPanelRenderer",
      "contents",
    ]);

    final related = <SongDetailed>[];

    for (final item in items) {
      final parsed = SongParser.parseSearchResult(item);
      related.add(parsed);
    }

    return related;
  }
}
