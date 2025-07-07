import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xono/ui/music_player.dart';
import '../providers.dart';

class BottomNav extends ConsumerWidget {
  const BottomNav({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BottomNavigationBar(
      currentIndex: ref.watch(bottomIndexProvider),
      onTap: (index){
        ref.read(bottomIndexProvider.notifier).state = index;
        if(index==1){
          showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                backgroundColor: Colors.transparent,
                child: SizedBox(
                  height: 200,
                  child: ref.read(currentlyPlayingProvider) !=null? MusicPlayer(): MusicPlayerShimmer(),
                ),
              );
            },
          );
        }
      } ,
      showUnselectedLabels: false,
      showSelectedLabels: false,
      unselectedItemColor: Colors.grey,
      selectedItemColor: Colors.deepPurpleAccent,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
        BottomNavigationBarItem(
          icon: Icon(Icons.panorama_fish_eye),
          label: 'Player',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings_outlined),
          label: 'Settings',
        ),
      ],
    );
  }
}
