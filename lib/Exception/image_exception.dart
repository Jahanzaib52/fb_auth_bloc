class ImageException implements Exception {
  String message;
  ImageException([this.message = "Image is required."]) {
    message = "Image Exception: $message";
  }
}
