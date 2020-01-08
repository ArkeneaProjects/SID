//
//  SKPhoto.swift
//  SKViewExample
//
//  Created by suzuki_keishi on 2015/10/01.
//  Copyright © 2015 suzuki_keishi. All rights reserved.
//

import UIKit

@objc public protocol SKPhotoProtocol: NSObjectProtocol {
    var index: Int { get set }
    var underlyingImage: UIImage! { get }
    var caption: String? { get }
    var contentMode: UIView.ContentMode { get set }
    func loadUnderlyingImageAndNotify()
    func checkCache()
}

// MARK: - SKPhoto
class SKPhoto: NSObject, SKPhotoProtocol {
    var index: Int = 0
    var underlyingImage: UIImage!
    var caption: String?
    var contentMode: UIView.ContentMode = .scaleAspectFill
    var shouldCachePhotoURLImage: Bool = false
    var photoURL: String!
    var objectLocation: ObjectLocation?
    
    override init() {
        super.init()
    }
    
    convenience init(onlyImage: UIImage) {
        self.init()
        underlyingImage = onlyImage
    }
    
    convenience init(image: UIImage, object: ObjectLocation?) {
        self.init()
       underlyingImage = image
        objectLocation = object
    }
    
    convenience init(url: String, object: ObjectLocation?) {
        self.init()
        photoURL = url
        objectLocation = object
    }
    
    convenience init(url: String, holder: UIImage?, object: ObjectLocation?) {
        self.init()
        photoURL = url
        underlyingImage = holder
        objectLocation = object
    }
    
    open func checkCache() {
        guard let photoURL = photoURL else {
            return
        }
        guard shouldCachePhotoURLImage else {
            return
        }
        
        if SKCache.sharedCache.imageCache is SKRequestResponseCacheable {
            let request = URLRequest(url: URL(string: photoURL)!)
            if let img = SKCache.sharedCache.imageForRequest(request) {
                underlyingImage = img//.drawRectangleOnImage(drawSize: CGRect(x: CGFloat(objectLocation?.left.floatValue() ?? 0.0), y: CGFloat(objectLocation?.top.floatValue() ?? 0.0), width: CGFloat(objectLocation?.width.floatValue() ?? 0.0), height: CGFloat(objectLocation?.height.floatValue() ?? 0.0)))
            }
        } else {
            if let img = SKCache.sharedCache.imageForKey(photoURL) {
                underlyingImage = img//.drawRectangleOnImage(drawSize: CGRect(x: CGFloat(objectLocation?.left.floatValue() ?? 0.0), y: CGFloat(objectLocation?.top.floatValue() ?? 0.0), width: CGFloat(objectLocation?.width.floatValue() ?? 0.0), height: CGFloat(objectLocation?.height.floatValue() ?? 0.0)))
            }
        }
    }
    
    open func loadUnderlyingImageAndNotify() {
        guard photoURL != nil, let URL = URL(string: photoURL) else { return }
        
        // Fetch Image
        let session = URLSession(configuration: SKPhotoBrowserOptions.sessionConfiguration)
        var task: URLSessionTask?
        task = session.dataTask(with: URL, completionHandler: { [weak self] (data, response, error) in
            guard let `self` = self else { return }
            defer { session.finishTasksAndInvalidate() }
            
            guard error == nil else {
                DispatchQueue.main.async {
                    self.loadUnderlyingImageComplete()
                }
                return
            }
            
            if let data = data, let response = response, let image = UIImage(data: data) {
                if self.shouldCachePhotoURLImage {
                    if SKCache.sharedCache.imageCache is SKRequestResponseCacheable {
                        SKCache.sharedCache.setImageData(data, response: response, request: task?.originalRequest)
                    } else {
                        SKCache.sharedCache.setImage(image, forKey: self.photoURL)
                    }
                }
                DispatchQueue.main.async {
                    self.underlyingImage = image//.drawRectangleOnImage(drawSize: CGRect(x: CGFloat(self.objectLocation?.left.floatValue() ?? 0.0), y: CGFloat(self.objectLocation?.top.floatValue() ?? 0.0), width: CGFloat(self.objectLocation?.width.floatValue() ?? 0.0), height: CGFloat(self.objectLocation?.height.floatValue() ?? 0.0)))
                    self.loadUnderlyingImageComplete()
                }
            }
            
        })
        task?.resume()
    }
    
    open func loadUnderlyingImageComplete() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: SKPHOTO_LOADING_DID_END_NOTIFICATION), object: self)
    }
    
}

// MARK: - Static Function

extension SKPhoto {
    public static func photoWithImage(_ image: UIImage) -> SKPhoto {
        return SKPhoto(onlyImage: image)
    }
    
    public static func photoWithImage(_ image: UIImage, object: ObjectLocation?) -> SKPhoto {
        return SKPhoto(image: image, object: object)
    }
    
    public static func photoWithImageURL(_ url: String, object: ObjectLocation?) -> SKPhoto {
        return SKPhoto(url: url, object: object)
    }
    
    public static func photoWithImageURL(_ url: String, holder: UIImage?, object: ObjectLocation?) -> SKPhoto {
        return SKPhoto(url: url, holder: holder, object: object)
    }
}
