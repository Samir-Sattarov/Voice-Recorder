import 'package:flutter/material.dart';

class RecordButtonWidget extends StatefulWidget {
  final VoidCallback onTap;
  const RecordButtonWidget({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  State<RecordButtonWidget> createState() => _RecordButtonWidgetState();
}

class _RecordButtonWidgetState extends State<RecordButtonWidget> {
  bool isRecording = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isRecording = !isRecording;
        });
        widget.onTap.call();
      },
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: const Color(0xff8E8D92),
            width: 3,
          ),
        ),
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: isRecording ? 35 : 55,
            height: isRecording ? 35 : 55,
            decoration: BoxDecoration(
              color: isRecording ? Colors.orange : Colors.yellow.shade600,
              borderRadius: BorderRadius.circular(
                isRecording ? 4 : 60,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
