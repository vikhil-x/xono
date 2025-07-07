import 'package:dart_ytmusic_api/dart_ytmusic_api.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'dart:developer';
class Scraper{
  late YoutubeExplode explode;
  late YTMusic ytMusic;

  initialize() async{
    explode = YoutubeExplode();
    ytMusic = YTMusic();
    await ytMusic.initialize();
  }

  Future<Uri> getUri(String videoId) async{
    final manifest = await explode.videos.streamsClient.getManifest(videoId);
    final url = manifest.audioOnly.withHighestBitrate().url;
    return url;
  }

  Future<List<SongDetailed>> searchSongs(String query) async{
    final searchResults = await ytMusic.searchSongs(query);
    return searchResults;
  }
}