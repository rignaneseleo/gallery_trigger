import Flutter
import UIKit

public class SwiftGallerytriggerPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "gallerytrigger", binaryMessenger: registrar.messenger())
    let instance = SwiftGallerytriggerPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard let args = call.arguments else {
        result("iOS could not recognize flutter arguments in method: (sendParams)")
        return
    }
    
    switch(call.method){
    case "addPicInIOSAlbum":
        let albumName : String = ((args as AnyObject)["album"]! as? String)!
        let path : String = ((args as AnyObject)["path"]! as? String)!
        
        self?.getAlbum(title: albumName,completionHandler:{ (album) -> Void in
            self?.createPhotoOnAlbum(path: path, album: album!)
        })
        result(true)
        return
    case "addVidInIOSAlbum":
        let albumName : String = ((args as AnyObject)["album"]! as? String)!
        let path : String = ((args as AnyObject)["path"]! as? String)!
        
        self?.getAlbum(title: albumName,completionHandler:{ (album) -> Void in
            self?.createVideoOnAlbum(path: path, album: album!)
        })
        result(true)
        return
    default:
        result(FlutterMethodNotImplemented)
        return
    }
    
  }
    
    
    func createPhotoOnAlbum(path: String, album: PHAssetCollection) {
        PHPhotoLibrary.shared().performChanges({
            // Request creating an asset from the image
            let createAssetRequest = PHAssetChangeRequest.creationRequestForAsset(from: UIImage(contentsOfFile: path)!)
            // Request editing the album
            guard let albumChangeRequest = PHAssetCollectionChangeRequest(for: album) else {
                print("Album change request has failed")
                return
            }
            // Get a placeholder for the new asset and add it to the album editing request
            guard let photoPlaceholder = createAssetRequest.placeholderForCreatedAsset else {
                print("Photo Placeholder is null")
                return
            }
            albumChangeRequest.addAssets([photoPlaceholder] as NSArray)
        }, completionHandler: { success, error in
            if success {
                // Saved successfully!
                print("Pic saved successfully in the IOS album!")
            }
            else if let e = error {
                print("error = ", e)
            }
            else {
                // Save photo failed with no error
                print("Save photo failed with no error")
            }
        })
    }
    
    func createVideoOnAlbum(path: String, album: PHAssetCollection) {
        PHPhotoLibrary.shared().performChanges({
            // Request creating an asset from the image
            let createAssetRequest = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: URL(string: path)!)
            // Request editing the album
            guard let albumChangeRequest = PHAssetCollectionChangeRequest(for: album) else {
                print("Album change request has failed")
                return
            }
            // Get a placeholder for the new asset and add it to the album editing request
            guard let photoPlaceholder = createAssetRequest?.placeholderForCreatedAsset else {
                print("Photo Placeholder is null")
                return
            }
            albumChangeRequest.addAssets([photoPlaceholder] as NSArray)
        }, completionHandler: { saved, error in
            if saved {
                print("Video saved successfully in the IOS album!")
            } else if let e = error {
                print("Error saving video in the IOS album: ",e)
            } else {print("Error saving video in the IOS album: ")}
        })
    }
    
    func getAlbum(title: String, completionHandler: @escaping (PHAssetCollection?) -> ()) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            let fetchOptions = PHFetchOptions()
            fetchOptions.predicate = NSPredicate(format: "title = %@", title)
            let collections = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
            
            if let album = collections.firstObject {
                completionHandler(album)
            } else {
                self?.createAlbum(title: title, completionHandler: { (album) in
                    completionHandler(album)
                })
            }
        }
    }
    
    func createAlbum(title: String, completionHandler: @escaping (PHAssetCollection?) -> ()) {
        DispatchQueue.global(qos: .background).async {
            var placeholder: PHObjectPlaceholder?
            
            PHPhotoLibrary.shared().performChanges({
                let createAlbumRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: title)
                placeholder = createAlbumRequest.placeholderForCreatedAssetCollection
            }, completionHandler: { (created, error) in
                var album: PHAssetCollection?
                if created {
                    let collectionFetchResult = placeholder.map { PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [$0.localIdentifier], options: nil) }
                    album = collectionFetchResult?.firstObject
                }
                completionHandler(album)
            })
        }
    }
    
}
