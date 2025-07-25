import 'package:dart_ytmusic_api/types.dart';
import 'package:flutter/material.dart';
import '../providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'lyric_widget_shimmer.dart';
import '../tools/lyric_manager.dart';

class LyricWidget extends ConsumerWidget {
  const LyricWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final songAsync = ref.watch(currentSongProvider);

    return songAsync.maybeWhen(
      data: (song) {
        if (song == null) {
          return const SizedBox.shrink();
        }

        final duration = ref.read(audioPlayerProvider).duration?.inSeconds.toString() ?? "";
        final lyricsAsync = ref.watch(lyricsProvider((song,duration)));
        final positionAsync = ref.watch(positionProvider);

        return _LyricWidgetDisplay(
          song: song,
          lyricsAsync: lyricsAsync,
          positionAsync: positionAsync,
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}

class _LyricWidgetDisplay extends ConsumerStatefulWidget {
  final SongDetailed song;
  final AsyncValue<List<LyricLine>> lyricsAsync;
  final AsyncValue<Duration> positionAsync;

  const _LyricWidgetDisplay({
    required this.song,
    required this.lyricsAsync,
    required this.positionAsync,
  });

  @override
  ConsumerState<_LyricWidgetDisplay> createState() => _LyricWidgetDisplayState();
}

class _LyricWidgetDisplayState extends ConsumerState<_LyricWidgetDisplay> {
  final _scrollController = ScrollController();
  int _currentIndex = 0;

  static const double _lineHeight = 50;
  static const double _widgetHeight = _lineHeight * 3;

  @override
  Widget build(BuildContext context) {
    final lyricsAsync = widget.lyricsAsync;
    final positionAsync = widget.positionAsync;

    positionAsync.whenData((position) {
      _updateCurrentIndex(position, lyricsAsync.asData?.value ?? []);
    });

    return lyricsAsync.when(
      loading: () => const LyricWidgetShimmer(),
      error: (e, _) => const Center(child: Text("Error loading lyrics")),
      data: (lyrics) {
        if (lyrics.isEmpty) {
          return const Center(
            child: Text(
              'No lyrics available',
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        return SizedBox(
          height: _widgetHeight,
          width: 350,
          child: ListView.builder(
            controller: _scrollController,
            itemExtent: _lineHeight,
            itemCount: lyrics.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final line = lyrics[index];
              final isCurrent = index == _currentIndex;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 250),
                  style: TextStyle(
                    fontSize: isCurrent ? 14 : 10,
                    color: isCurrent ? Colors.white : Colors.grey,
                    fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: line.text.isEmpty
                        ? Icon(
                      Icons.music_note,
                      color: isCurrent ? Colors.white : Colors.grey,
                    )
                        : Text(
                      line.text,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _updateCurrentIndex(Duration position, List<LyricLine> lyrics) {
    if (lyrics.isEmpty) return;

    int newIndex = _currentIndex;

    for (int i = 0; i < lyrics.length; i++) {
      if (position < lyrics[i].timeStamp) {
        newIndex = (i - 1).clamp(0, lyrics.length - 1);
        break;
      } else {
        newIndex = i;
      }
    }

    if (newIndex != _currentIndex) {
      setState(() => _currentIndex = newIndex);

      final targetOffset =
          (_currentIndex * _lineHeight) - (_widgetHeight / 2) + (_lineHeight / 2);

      _scrollController.animateTo(
        targetOffset.clamp(0.0, _scrollController.position.maxScrollExtent),
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }
}
