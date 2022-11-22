class CauinCommentException extends Exception {
  factory CauinCommentException(String message) {
    return Exception(message) as CauinCommentException;
  }
}
