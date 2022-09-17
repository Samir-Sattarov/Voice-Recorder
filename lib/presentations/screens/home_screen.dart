import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:voice/presentations/widgets/record_card_widget.dart';

import '../../data/entity/record_entity.dart';
import '../widgets/record_button_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final recorder = Record();
  final player = AudioPlayer();
  double volume = 0.5;

  Duration? duration;
  Duration? position;
  String? audioPath;

  bool isRecording = false;

  late final Directory directory;
  @override
  void initState() {
    super.initState();
    initialize();
    listenPlayer();
  }

  listenPlayer() async {
    player.createPositionStream().listen((currentDuration) {
      setState(() {
        position = currentDuration;
        log('position $position');
      });
    });
  }

  initialize() async {
    await Permission.microphone.request();
    isRecording = await recorder.isRecording();
    directory = await getTemporaryDirectory();
  }

  startRecording() async {
    final saveTo = '${directory.path}/audio.aac';
    await recorder.start(
      path: saveTo,
      encoder: AudioEncoder.aacLc,
    );

    setState(() {
      isRecording = true;
    });
  }

  stopRecording() async {
    final path = await recorder.stop();

    setState(() {
      isRecording = false;
    });
    setState(() {
      audioPath = path;
    });

    await player.setFilePath(
      path!,
    );

    await player.stop();
    setState(() {
      duration = player.duration;
    });
  }

  playAudio() async {
    await player.play();
  }

  pauseAudio() async {
    await player.pause();
  }

  final List<RecordEntity> records = [
    RecordEntity(
      path: 'path',
      duration: const Duration(seconds: 1),
      time: '03:12',
      name: 'Name',
    ),
    RecordEntity(
      path: 'path',
      duration: const Duration(seconds: 1),
      time: '12:12',
      name: 'Name',
    ),
    RecordEntity(
      path: 'path',
      duration: const Duration(seconds: 1),
      time: '09:04',
      name: 'Name',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            title: const Text('All Saves'),
            titleTextStyle: const TextStyle(
              fontWeight: FontWeight.w800,
            ),
            surfaceTintColor: Colors.white,
            backgroundColor: Colors.white,
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              childCount: records.length,
              (BuildContext context, int index) {
                return RecordCardWidget(
                  record: records[index],
                );
              },
            ),
          ),
        ],
      ),
      // body: SizedBox(
      //   width: MediaQuery.of(context).size.width,
      //   height: MediaQuery.of(context).size.height,
      //   child: Column(
      //     // mainAxisAlignment: MainAxisAlignment.center,
      //     crossAxisAlignment: CrossAxisAlignment.center,
      //     // mainAxisSize: MainAxisSize.min,
      //     children: [
      //       Expanded(
      //         child: SafeArea(
      //           child: Column(
      //             children: [
      //               const SizedBox(height: 100),
      //               Slider(
      //                 min: 0.1,
      //                 max: 1,
      //                 value: volume,
      //                 onChanged: (value) async {
      //                   setState(() {
      //                     volume = value;
      //                     _changeVolume(volume);
      //                   });
      //                 },
      //               ),
      //               Text("Volume $volume"),
      //               Slider(
      //                 max: duration?.inSeconds.toDouble() ?? 1,
      //                 value: position?.inSeconds.toDouble() ?? 0,
      //                 onChanged: (value) {
      //                   setState(() {
      //                     position = Duration(seconds: value.toInt());
      //                     player.seek(position);
      //                   });
      //                 },
      //               ),
      //               Padding(
      //                 padding: const EdgeInsets.symmetric(horizontal: 60),
      //                 child: Row(
      //                   children: [
      //                     Text(position?.inSeconds.toInt().toString() ?? ''),
      //                     const Spacer(),
      //                     Text(duration?.inSeconds.toInt().toString() ?? ''),
      //                   ],
      //                 ),
      //               ),
      //               const SizedBox(height: 10),
      //               Row(
      //                 mainAxisAlignment: MainAxisAlignment.center,
      //                 children: [
      //                   ElevatedButton(
      //                     onPressed: () async {
      //                       if (audioPath != null && !player.playing) {
      //                         await player.play();
      //                       }
      //                     },
      //                     child: const Icon(Icons.play_arrow_rounded),
      //                   ),
      //                   const SizedBox(width: 10),
      //                   ElevatedButton(
      //                     onPressed: () async {
      //                       await player.pause();
      //                     },
      //                     child: const Icon(Icons.pause),
      //                   ),
      //                 ],
      //               ),
      //             ],
      //           ),
      //         ),
      //       ),
      //       Align(
      //         alignment: Alignment.bottomCenter,
      //         child: Container(
      //           color: const Color(0xffF2F1F6),
      //           padding: EdgeInsets.only(
      //             bottom: MediaQuery.of(context).padding.bottom,
      //           ),
      //           height: 130,
      //           child: Center(
      //             child: RecordButtonWidget(
      //               onTap: () async {
      //                 if (isRecording) {
      //                   await stopRecording();
      //                 } else {
      //                   await startRecording();
      //                 }
      //               },
      //             ),
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
      // body: SizedBox(
      //   width: MediaQuery.of(context).size.width,
      //   height: MediaQuery.of(context).size.height,
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     crossAxisAlignment: CrossAxisAlignment.center,
      //     children: [
      //       ElevatedButton(
      //         onPressed: () async {
      //           if (isRecording) {
      //             await stopRecording();
      //           } else {
      //             await startRecording();
      //           }
      //         },
      //         child: Icon(
      //           !isRecording ? Icons.mic_none : Icons.mic_off_outlined,
      //         ),
      //       ),
      //       const SizedBox(height: 100),
      //       Slider(
      //         min: 0.1,
      //         max: 1,
      //         value: volume,
      //         onChanged: (value) async {
      //           setState(() {
      //             volume = value;
      //             _changeVolume(volume);
      //           });
      //         },
      //       ),
      //       Text("Volume $volume"),
      //       Slider(
      //         max: duration?.inSeconds.toDouble() ?? 1,
      //         value: position?.inSeconds.toDouble() ?? 0,
      //         onChanged: (value) {
      //           setState(() {
      //             position = Duration(seconds: value.toInt());
      //             player.seek(position);
      //           });
      //         },
      //       ),
      //       Padding(
      //         padding: const EdgeInsets.symmetric(horizontal: 60),
      //         child: Row(
      //           children: [
      //             Text(position?.inSeconds.toInt().toString() ?? ''),
      //             const Spacer(),
      //             Text(duration?.inSeconds.toInt().toString() ?? ''),
      //           ],
      //         ),
      //       ),
      //       const SizedBox(height: 10),
      //       Row(
      //         mainAxisAlignment: MainAxisAlignment.center,
      //         children: [
      //           ElevatedButton(
      //             onPressed: () async {
      //               if (audioPath != null && !player.playing) {
      //                 await player.play();
      //               }
      //             },
      //             child: const Icon(Icons.play_arrow_rounded),
      //           ),
      //           const SizedBox(width: 10),
      //           ElevatedButton(
      //             onPressed: () async {
      //               await player.pause();
      //             },
      //             child: const Icon(Icons.pause),
      //           ),
      //         ],
      //       )
      //     ],
      //   ),
      // ),
      bottomNavigationBar: Container(
        color: const Color(0xffF2F1F6),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom,
        ),
        height: 130,
        child: Center(
          child: RecordButtonWidget(
            onTap: () async {
              if (isRecording) {
                await stopRecording();
              } else {
                await startRecording();
              }
            },
          ),
        ),
      ),
    );
  }
}
