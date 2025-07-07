import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xono/tools/player_control.dart';
import 'core/music_db.dart';
import 'package:just_audio/just_audio.dart';
import 'core/yt_scrape.dart';

final bottomIndexProvider = StateProvider<int>((ref) => 1);
final musicProvider = StateProvider<List<String>>((ref) => musicList);
final audioPlayerProvider = Provider<AudioPlayer>((ref) {
  final player = AudioPlayer();
  ref.onDispose(() => player.dispose());
  return player;
});
/*final ytMusicProvider = FutureProvider<YTMusic>((ref) async {
  final ytMusic = YTMusic();
  await ytMusic.initialize();
  return ytMusic;
});*/

final playerControlProvider = Provider<PlayerControl>((ref) => PlayerControl(ref));
final pauseProvider = StateProvider<bool>((ref) => true);
final ytScraperProvider = FutureProvider<Scraper>((ref) async{
  final scraper = Scraper();
  await scraper.initialize();
  return scraper;
});