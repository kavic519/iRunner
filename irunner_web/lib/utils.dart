String formatDuration(int seconds) {
  final minutes = (seconds / 60).floor().toString().padLeft(2, '0');
  final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
  return '$minutes:$remainingSeconds';
}

String formatDistance(double distance) {
  return '${(distance / 1000).toStringAsFixed(2)} km';
}
