String formatDuration(Duration duration) {
  var result = '방금';
  if (duration.inDays >= 1) {
    result = '${duration.inDays}일';
  } else if (duration.inHours >= 1) {
    result = '${duration.inHours}시간';
  } else if (duration.inMinutes >= 1) {
    result = '${duration.inMinutes}분';
  } else if (duration.inSeconds >= 1) {
    result = '${duration.inSeconds}초';
  }

  return result;
}
