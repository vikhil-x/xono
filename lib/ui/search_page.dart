import 'package:flutter/material.dart';
import 'package:dart_ytmusic_api/types.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xono/providers.dart';
import 'search_item.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});
  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final controller = TextEditingController();
  List<SongDetailed> listOfSongs = [];
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          SearchBar(
            leading: IconButton(
              icon: Icon(Icons.search, size: 24),
              onPressed: fillSongList,
            ),
            trailing: [
              IconButton(
                icon: Icon(Icons.clear, size: 24),
                onPressed: () {
                  controller.clear();
                },
              ),
            ],
            hintText: 'Search something....',
            controller: controller,
            padding: WidgetStateProperty.all(
              EdgeInsets.symmetric(horizontal: 8),
            ),
            textInputAction: TextInputAction.search,
            onSubmitted: fillSongList,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: isLoading
                  ? ListView.builder(
                      itemCount: 10,
                      itemBuilder: (context, index) => const ShimmerTile(),
                      physics: const BouncingScrollPhysics(),
                    )
                  : ListView.builder(
                      itemCount: listOfSongs.length,
                      itemBuilder: (context, index) =>
                          SearchItemTile(song: listOfSongs[index]),
                      physics: const BouncingScrollPhysics(),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  void fillSongList([String? text]) async {
    setState(() {
      isLoading = true;
    });

    final scraper = await ref.read(ytScraperProvider.future);
    final songs = await scraper.searchSongs(text ?? controller.text);

    setState(() {
      listOfSongs = songs;
      isLoading = false;
    });
  }
}
