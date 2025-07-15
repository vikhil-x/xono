import 'package:http/http.dart' as http;
import 'package:dart_ytmusic_api/types.dart';
import 'dart:convert';

Future<String> getSyncedLyrics(SongDetailed song) async {
  final response = await getResponse(song);

  if(response.statusCode == 200){
    final decoded = jsonDecode(response.body);
    final lyrics = decoded["syncedLyrics"];
    return lyrics as String;
  }
  return "";
}

Future<String> getPlainLyrics(SongDetailed song) async {
  final response = await getResponse(song);

  if(response.statusCode == 200){
    final decoded = jsonDecode(response.body);
    final lyrics = decoded["plainLyrics"];
    return lyrics as String;
  }
  return "";
}

Future<http.Response> getResponse(SongDetailed song) async {
  final response = await http.get(Uri.parse('https://lrclib.net/api/get?'), headers: {
    "artist_name": Uri.encodeComponent(song.artist.name),
    "track_name": Uri.encodeComponent(song.name),
    "album_name": Uri.encodeComponent(song.album?.name ?? ""),
    "duration": Uri.encodeComponent(song.duration.toString()),
  });
  return response;
}

class LyricLine{
  final String text;
  final Duration timeStamp;
  LyricLine(this.text, this.timeStamp);
}

List<LyricLine> getLyricLines(String lyrics){
  if(lyrics.isEmpty) return [];

  final regex = RegExp(r'\[(\d{2}):(\d{2}\.\d{2})\](.*)');
  final lines = <LyricLine>[];

  for(final line in lyrics.split('\n')){
    final match = regex.firstMatch(line);
    if(match != null){
      final minutes = int.parse(match.group(1)!);
      final seconds = double.parse(match.group(2)!);
      final millis = ((minutes * 60 + seconds) * 1000).round();
      final text = match.group(3)!.trim();
      final timeStamp = Duration(milliseconds: millis);
      lines.add(LyricLine(text, timeStamp));
    }
  }

  return lines;
}