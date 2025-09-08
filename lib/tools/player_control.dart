import 'package:dart_ytmusic_api/dart_ytmusic_api.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers.dart';
import 'yt_scrape.dart';

class PlayerControl {
  final AudioPlayer player;
  final Ref ref;
  int index = 0;
  List<SongDetailed> currentPlaylist = [];

  PlayerControl(this.ref) : player = ref.read(audioPlayerProvider);

  Future<void> playNext() async {
    if (currentPlaylist.isEmpty) return;
    index = (index + 1) % currentPlaylist.length;
    await play(currentPlaylist[index]);
  }

  Future<void> playPrev() async {
    if (currentPlaylist.isEmpty) return;
    index = (index - 1 + currentPlaylist.length) % currentPlaylist.length;
    await play(currentPlaylist[index]);
  }

  Future<void> play([SongDetailed? song, bool? resetQueue]) async {
    if (song != null) {
      final scraper = await ref.read(ytScraperProvider.future);
      final url = await scraper.getUri(song.videoId);
      await player.setAudioSource(AudioSource.uri(url, tag: song));
      await player.play();

      if (resetQueue ?? false) {
        currentPlaylist = await ref.read(
          playlistProvider((song, false)).future,
        );
        index = 0;
      }
    } else {
      await player.play();
    }
  }

  Future<List<SongDetailed>> enqueueSongs({
    SongDetailed? song,
    required bool artist,
    Scraper? scraper,
  }) async {
    song ??= await ref.watch(currentSongProvider.future);
    scraper ??= await ref.read(ytScraperProvider.future);
    index = 0;
    final relatedSongs = await scraper!.getRelatedSongs(song!, artist);
    currentPlaylist = [song, ...relatedSongs];
    return currentPlaylist;
  }

  Future<void> pause() async => await player.pause();
}
