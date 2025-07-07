import 'package:just_audio/just_audio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xono/core/yt_scrape.dart';
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
    await player.setAudioSource(AudioSource.asset('assets/music_files/$fileName'));
    await player.play();
  }

  Future<void> play([Uri? url]) async {
    if (url != null) {
      await player.stop();
      await player.setAudioSource(AudioSource.uri(url));
    }
    await player.play();
  }

  void pause() async => await player.pause();
}
