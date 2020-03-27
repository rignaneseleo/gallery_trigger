import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mime_type/mime_type.dart';

enum FileType { image, video }

 class GalleryTrigger {
  static const MethodChannel _channel = const MethodChannel('gallerytrigger');

  /// Adds a resource file with file path [filePath] to the native systems galleries (on iOS is Photos, on Android is MediaStore).
  ///
  /// Returns `false` is the action is not possible, otherwise `true`.
  /// Throws an [ArgumentError] if there is the arguments are not valid
  static Future<bool> addResourceInGallery({
    @required String filePath,
    @required String albumName,
  }) async {
    assert(filePath != null && filePath.isNotEmpty);
    assert(albumName != null && albumName.isNotEmpty);

    if (filePath == null || filePath.isEmpty)
      throw (ArgumentError("filePath not valid"));

    // Check if the path corresponds to a resource file that can be added in galleries
    FileType fileType;
    if (mime(filePath).contains("image")) {
      fileType = FileType.image;
    } else if (mime(filePath).contains("video")) {
      fileType = FileType.video;
    }
    if (fileType == null) return false;

    if (Platform.isIOS) {
      if (albumName == null || albumName.isEmpty)
        throw (ArgumentError("albumName is not valid"));

      switch (fileType) {
        case FileType.image:
          await _channel.invokeMethod(
              'addPicInIOSAlbum', {"path": filePath, "album": albumName});
          break;
        case FileType.video:
          await _channel.invokeMethod(
              'addVidInIOSAlbum', {"path": filePath, "album": albumName});
          break;
      }
      return true;
    } else if (Platform.isAndroid) {
      await _channel.invokeMethod('refreshMediaStore', {"path": filePath});
      return true;
    }
    return false;
  }
}


