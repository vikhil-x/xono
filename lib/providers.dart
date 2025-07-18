import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xono/tools/player_control.dart';
import 'package:just_audio/just_audio.dart';
import 'tools/yt_scrape.dart';
import 'package:dart_ytmusic_api/types.dart';
import 'tools/lyric_manager.dart';

final bottomIndexProvider = StateProvider<int>((ref) => 1);

final audioPlayerProvider = Provider<AudioPlayer>((ref) {
  final player = AudioPlayer();
  ref.onDispose(() => player.dispose());
  return player;
});

final playerControlProvider = Provider<PlayerControl>(
  (ref) => PlayerControl(ref),
);
final ytScraperProvider = FutureProvider<Scraper>((ref) async {
  final scraper = Scraper();
  await scraper.initialize();
  return scraper;
});

final playerStateProvider = StreamProvider<PlayerState>((ref) {
  final audioPlayer = ref.watch(audioPlayerProvider);
  return audioPlayer.playerStateStream;
});

final progressProvider = StreamProvider<double>((ref) async* {
  final audioPlayer = ref.watch(audioPlayerProvider);
  await for (final pos in audioPlayer.positionStream) {
    final duration = audioPlayer.duration;
    if (duration != null && duration.inMilliseconds > 0) {
      yield pos.inMilliseconds / duration.inMilliseconds;
    } else {
      yield 0.0;
    }
  }
});

final positionProvider = StreamProvider<Duration>((ref) {
  final audioPlayer = ref.watch(audioPlayerProvider);
  return audioPlayer.positionStream;
});

final currentSongProvider = StreamProvider<SongDetailed?>((ref) {
  final player = ref.watch(audioPlayerProvider);
  return player.sequenceStateStream.map((seqState) {
    final source = seqState?.currentSource;
    if (source?.tag is SongDetailed) {
      return source!.tag as SongDetailed;
    }
    return null;
  });
});

final playlistProvider = StateProvider<List<SongDetailed>>((ref) => []);

final lyricsProvider = FutureProvider.family<List<LyricLine>, SongDetailed>((ref, song) async {
  final duration = ref.read(audioPlayerProvider).duration?.inSeconds;
  final raw = await getSyncedLyrics(song, duration?.toString() ?? "");
  return getLyricLines(raw);
});