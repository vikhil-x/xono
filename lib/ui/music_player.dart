import 'package:dart_ytmusic_api/dart_ytmusic_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xono/providers.dart';
import '../tools/player_control.dart';
import 'package:just_audio/just_audio.dart';

export 'music_player_shimmer.dart';

class MusicPlayer extends ConsumerStatefulWidget {
  const MusicPlayer({super.key});

  @override
  ConsumerState<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends ConsumerState<MusicPlayer> {
  late final PlayerControl controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    controller = ref.read(playerControlProvider);
  }

  @override
  Widget build(BuildContext context) {
    final SongDetailed? song = ref.watch(currentlyPlayingProvider);
    final isPlaying = ref.watch(playerStateProvider).when(
      data: (state) =>
      state.playing && state.processingState != ProcessingState.completed,
      loading: () => false,
      error: (e, st) => false,
    );
    final progressAsync = ref.watch(progressProvider);
    final progress = progressAsync.asData?.value ?? 0.0;

    return SizedBox(
      width: 350,
      height: 200,
      child: Column(
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 3,
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                children: [
                  ClipOval(
                    child: Image.network(
                      song!.thumbnails.last.url,
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Container(width: 120, height: 120, color: Colors.black),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 8, right: 8, top: 8),
                      child: Column(
                        children: [
                          Text(
                            song.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'san francisco',
                            ),
                          ),
                          Text(
                            song.artist.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                          SizedBox(height: 20),
                          FractionallySizedBox(
                            widthFactor: 0.9,
                            child: LinearProgressIndicator(
                              value: isPlaying? progress.clamp(0.0,1.0): 0.0,
                              borderRadius: BorderRadiusGeometry.circular(16),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                icon: Icon(Icons.skip_previous),
                                onPressed: () {
                                  controller.playPrev();
                                },
                                iconSize: 30,
                              ),
                              IconButton(
                                icon: isPlaying
                                    ? Icon(Icons.pause)
                                    : Icon(Icons.play_arrow),
                                onPressed: () {
                                  if (isPlaying) {
                                    controller.pause();
                                  } else {
                                    controller.play();
                                  }
                                },
                                iconSize: 30,
                              ),
                              IconButton(
                                icon: Icon(Icons.skip_next),
                                onPressed: () {
                                  controller.playNext();
                                },
                                iconSize: 30,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FilledButton(
                  onPressed: () {},
                  child: Icon(Icons.all_inclusive),
                ),
                FilledButton(
                  onPressed: () {},
                  child: Icon(Icons.favorite_border),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}