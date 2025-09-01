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
    final musicList = ref.read(playlistProvider);
    if (musicList.isEmpty) return;
    index = (index + 1) % musicList.length;
    await play(musicList[index]);
  }

  Future<void> playPrev() async {
    final musicList = ref.read(playlistProvider);
    if (musicList.isEmpty) return;
    index = (index - 1 + musicList.length) % musicList.length;
    await play(musicList[index]);
  }

  Future<void> play([SongDetailed? song, bool? resetQueue]) async {
    if (song != null) {
      final scraper = await ref.read(ytScraperProvider.future);
      final url = await scraper.getUri(song.videoId);
      await player.setAudioSource(AudioSource.uri(url, tag: song));
      await player.play();

      if(resetQueue ?? false) await enqueueSongs(song: song, artist: false, scraper: scraper);
    }
    else{
      await player.play();
    }
  }

  Future<void> enqueueSongs({SongDetailed? song, required bool artist, Scraper? scraper}) async{
    ref.read(playlistProvider.notifier).state = [];
    song ??= await ref.watch(currentSongProvider.future);
    scraper ??= await ref.read(ytScraperProvider.future);
    index = 0;
    final relatedSongs = await scraper!.getRelatedSongs(song!, artist);
    ref.read(playlistProvider.notifier).state = [song,...relatedSongs];
  }

  void pause() async => await player.pause();
}
