# Flutter plugin: _gallerytrigger_
A Flutter plugin able to trigger the iOS and Android galleries in order to let them update and show a new resource.

## Why
When you download a picture or video file with your Flutter app you won't see it in the gallery until your device refreshes the internal database.
With this plugin you can manually trigger it and add the picture in [MediaStore](https://developer.android.com/reference/android/provider/MediaStore) on Android or in Photos in iOS.

## Use
```
  String path = await downloadPicFromNetwork();
  String album = "Example";
  await GalleryTrigger.addResourceInGallery(filePath: path, albumName: null);
```

## Possible Improvements
- Clean the procject (remove all the useless files and folders)
- Return a consistent bool value dipending on the procedure success/failure
- Merge the photo and video logics in swift
- Add resources on iOS without declaring an album name
