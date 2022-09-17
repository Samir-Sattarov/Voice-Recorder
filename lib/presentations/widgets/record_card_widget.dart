import 'package:flutter/material.dart';

import '../../data/entity/record_entity.dart';

class RecordCardWidget extends StatefulWidget {
  final RecordEntity record;
  const RecordCardWidget({Key? key, required this.record}) : super(key: key);

  @override
  State<RecordCardWidget> createState() => _RecordCardWidgetState();
}

class _RecordCardWidgetState extends State<RecordCardWidget> {
  bool openAdvancedMenu = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          openAdvancedMenu = !openAdvancedMenu;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.only(bottom: 3),
        height: openAdvancedMenu ? 200 : 100,
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(color: Colors.black26),
          ],
        ),
        child: Column(
          children: [
            Text(widget.record.path),
            Text(widget.record.time),
            Text(widget.record.duration.toString()),
          ],
        ),
      ),
    );
  }
}
