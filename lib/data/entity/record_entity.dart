class RecordEntity {
  final String path;
  final String time;
  final Duration duration;
  final String name;

  // String time = DateFormat('h:mm').format(DateTime.now());
  RecordEntity({
    required this.name,
    required this.path,
    required this.time,
    required this.duration,
  });
}
