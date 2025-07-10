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
    player.stop();
    final musicList = ref.read(musicProvider);
    index = (index + 1) % musicList.length;
    await _play(musicList[index]);
  }

  Future<void> playPrev() async {
    player.stop();
    final musicList = ref.read(musicProvider);
    index = (index - 1 + musicList.length) % musicList.length;
    await _play(musicList[index]);
  }

  Future<void> _play(String fileName) async {
    await player.setAudioSource(
      AudioSource.asset('assets/music_files/$fileName'),
    );
    await player.play();
  }

  Future<void> play([SongDetailed? song]) async {
    if (song != null) {
      final scraper = await ref.read(ytScraperProvider.future);
      final url = await scraper.getUri(song.videoId);
      await player.setAudioSource(AudioSource.uri(url, tag: song));
    }
    await player.play();
  }

  void pause() async => await player.pause();
}
