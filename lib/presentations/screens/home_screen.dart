import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double volume = 0.5;
  final recorder = FlutterSoundRecorder();
  final player = AudioPlayer();

  Duration? duration;
  Duration? position;
  String? audioPath;

  @override
  void initState() {
    super.initState();
    initialize();
    listenPlayer();
  }

  @override
  void dispose() {
    recorder.closeRecorder();
    super.dispose();
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
    await recorder.openRecorder();
  }

  startRecording() async {
    await recorder.startRecorder(
      toFile: 'audio.aac',
      codec: Codec.aacADTS,
    );
  }

  stopRecording() async {
    final path = await recorder.stopRecorder();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                if (recorder.isRecording) {
                  await stopRecording();
                } else {
                  await startRecording();
                }
                setState(() {});
              },
              child: Icon(
                !recorder.isRecording ? Icons.mic_none : Icons.mic_off_outlined,
              ),
            ),
            const SizedBox(height: 100),
            Slider(
              min: 0.1,
              max: 1,
              value: volume,
              onChanged: (value) async {
                setState(() {
                  volume = value;
                  _changeVolume(volume);
                });
              },
            ),
            Text("Volume $volume"),
            Slider(
              max: duration?.inSeconds.toDouble() ?? 1,
              value: position?.inSeconds.toDouble() ?? 0,
              onChanged: (value) {
                setState(() {
                  position = Duration(seconds: value.toInt());
                  player.seek(position);
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60),
              child: Row(
                children: [
                  Text(position?.inSeconds.toInt().toString() ?? ''),
                  const Spacer(),
                  Text(duration?.inSeconds.toInt().toString() ?? ''),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    if (audioPath != null && !player.playing) {
                      await player.play();
                    }
                  },
                  child: const Icon(Icons.play_arrow_rounded),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () async {
                    await player.pause();
                  },
                  child: const Icon(Icons.pause),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  _changeVolume(double newVolume) async {
    await player.setVolume(newVolume);
    setState(() {});
  }
}
