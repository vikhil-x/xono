import 'package:dart_ytmusic_api/types.dart';
import 'package:flutter/material.dart';
import '../tools/lyric_manager.dart';
import '../providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'lyric_widget_shimmer.dart';

class LyricWidget extends ConsumerStatefulWidget {
  final SongDetailed song;

  const LyricWidget({super.key, required this.song});

  @override
  ConsumerState<LyricWidget> createState() => _LyricWidgetState();
}

class _LyricWidgetState extends ConsumerState<LyricWidget> {
  final _scrollController = ScrollController();
  late final List<LyricLine> _lyrics;
  int _currentIndex = 0;
  bool _loading = true;

  static const double _lineHeight = 40;
  static const double _widgetHeight = _lineHeight * 3;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final duration = ref.read(audioPlayerProvider).duration?.inSeconds;
      final raw = await getSyncedLyrics(
        widget.song,
        duration?.toString() ?? "",
      );
      final parsed = getLyricLines(raw);
      if (mounted) {
        setState(() {
          _lyrics = parsed;
          _loading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final positionAsync = ref.watch(positionProvider);

    positionAsync.whenData((position) {
      _updateCurrentIndex(position);
    });

    if (_loading) return const LyricWidgetShimmer();
    if (_lyrics.isEmpty) {
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
        itemCount: _lyrics.length,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final line = _lyrics[index];
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
  }

  void _updateCurrentIndex(Duration position) {
    int newIndex = _currentIndex;

    for (int i = 0; i < _lyrics.length; i++) {
      if (position < _lyrics[i].timeStamp) {
        newIndex = (i - 1).clamp(0, _lyrics.length - 1);
        break;
      } else {
        newIndex = i;
      }
    }

    if (newIndex != _currentIndex) {
      setState(() {
        _currentIndex = newIndex;
      });
      final targetOffset =
          (_currentIndex * _lineHeight) -
          (_widgetHeight / 2) +
          (_lineHeight / 2);
      _scrollController.animateTo(
        targetOffset.clamp(0.0, _scrollController.position.maxScrollExtent),
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }
}
