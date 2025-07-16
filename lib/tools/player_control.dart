import 'package:dart_ytmusic_api/dart_ytmusic_api.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers.dart';

class PlayerControl {
  final AudioPlayer player;
  final Ref ref;
  int index = 0;

  PlayerControl(this.ref) : player = ref.read(audioPlayerProvider);

  Future<void> playNext() async {
    final musicList = ref.read(playlistProvider);
    index = (index + 1) % musicList.length;
    await play(musicList[index]);
  }

  Future<void> playPrev() async {
    final musicList = ref.read(playlistProvider);
    index = (index - 1 + musicList.length) % musicList.length;
    await play(musicList[index]);
  }

  Future<void> play([SongDetailed? song, bool? resetQueue]) async {
    if (song != null) {
      final scraper = await ref.read(ytScraperProvider.future);
      final url = await scraper.getUri(song.videoId);
      await player.setAudioSource(AudioSource.uri(url, tag: song));
      await player.play();

      if(resetQueue ?? false){
        ref.read(playlistProvider.notifier).state = [];
        index = 0;
        final relatedSongs = await scraper.getRelatedSongs(song);
        ref.read(playlistProvider.notifier).state = [song,...relatedSongs];
      }
    }
    else{
      await player.play();
    }
  }

  void pause() async => await player.pause();
}
