import '../lib/gallerytrigger.dart';

main() async {
  String path = await downloadPicFromNetwork();
  String album = "Example";
  GalleryTrigger.addResourceInGallery(filePath: path, albumName: null);
}

downloadPicFromNetwork() {
  // This is an example
  return "foo.jpg";
}
