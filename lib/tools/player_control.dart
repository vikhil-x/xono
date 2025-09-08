import 'package:dart_ytmusic_api/dart_ytmusic_api.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers.dart';
import 'yt_scrape.dart';

class PlayerControl {
  final AudioPlayer player;
  final Ref ref;
  int index = 0;

  PlayerControl(this.ref) : player = ref.read(audioPlayerProvider);

  Future<void> playNext() async {
    final queueType = ref.read(queueTypeProvider);
    final playlist = await ref.read(playlistProvider((null, queueType)).future);
    if (playlist.isEmpty) return;
    index = (index + 1) % playlist.length;
    await play(playlist[index]);
  }

  Future<void> playPrev() async {
    final queueType = ref.read(queueTypeProvider);
    final playlist = await ref.read(playlistProvider((null, queueType)).future);
    if (playlist.isEmpty) return;
    index = (index - 1 + playlist.length) % playlist.length;
    await play(playlist[index]);
  }

  Future<void> play([SongDetailed? song, bool? resetQueue]) async {
    if (song != null) {
      final scraper = await ref.read(ytScraperProvider.future);
      final url = await scraper.getUri(song.videoId);
      await player.setAudioSource(AudioSource.uri(url, tag: song));
      await player.play();

      if (resetQueue ?? false) {
        final queueType = ref.read(queueTypeProvider);
        await ref.refresh(playlistProvider((song, queueType)).future);
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

    final relatedSongs = await scraper!.getRelatedSongs(song!, artist);
    return [song, ...relatedSongs];
  }

  Future<void> pause() async => await player.pause();
}
