import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class MusicPlayerShimmer extends StatelessWidget {
  const MusicPlayerShimmer({super.key});

  @override
  Widget build(BuildContext context) {
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
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Shimmer.fromColors(
                    baseColor: Colors.grey.shade800,
                    highlightColor: Colors.grey.shade600,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 8, right: 8, top: 8),
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey.shade800,
                        highlightColor: Colors.grey.shade600,
                        child: Column(
                          children: [
                            Container(
                              height: 15,
                              width: 150,
                              //margin: const EdgeInsets.symmetric(vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            Container(
                              height: 8,
                              width: 100,
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            SizedBox(height: 20),
                            FractionallySizedBox(
                              widthFactor: 0.9,
                              child: LinearProgressIndicator(
                                value: 0.5,
                                backgroundColor: Colors.grey,
                                borderRadius: BorderRadiusGeometry.circular(16),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.skip_previous),
                                  onPressed: () {
                                    /*ref.read(pauseProvider.notifier).state = false;
                                  controller.playPrev();*/
                                  },
                                  iconSize: 30,
                                ),
                                IconButton(
                                  icon: Icon(Icons.play_arrow),
                                  onPressed: () {
                                    /*if (isPaused) {
                                    controller.play();
                                  } else {
                                    controller.pause();
                                  }
                                  ref.read(pauseProvider.notifier).state = !isPaused;*/
                                  },
                                  iconSize: 30,
                                ),
                                IconButton(
                                  icon: Icon(Icons.skip_next),
                                  onPressed: () {
                                    /*ref.read(pauseProvider.notifier).state = false;
                                  controller.playNext();*/
                                  },
                                  iconSize: 30,
                                ),
                              ],
                            ),
                          ],
                        ),
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
