//
//  ImageFetchable.swift
//  ImageCachingKit
//
//  Created by Stoyan Stoyanov on 21/04/2020.
//  Copyright © 2020 Stoyan Stoyanov. All rights reserved.
//

import Foundation


/// A protocol that makes everyone that conforms to it able to download images from url with two layers of caching - in memory and on disk. Get the image by invoking `fetchPreview(withCompletion:)`.
///
/// Using it is really easy with these simple steps:
/// - conform to this protocol (you are required to have a `url` and `inMemoryPreview` properties)
/// - invoke `fetchPreview(withCompletion:)` and you will get your image, the rest is taking care of the framework.
public protocol ImageFetchable: AnyObject {
    
    /// The `URL` of the image that you want to fetch a preview of. Part of `ImageFetchable` protocol.
    var url: URL? { get }
    
    /// Name of local image that will be passed as a result from `fetchPreview(withCompletion:)` from `ImageFetchable` protocol in case the `url` is `nil`.
    var dummyImageName: String? { get }
    
    /// A property to act as a in memory cache for a `ImageFetchable` object.
    var inMemoryPreview: UIImage? { get set }
    
    /// True when the current image is already in memory or on disk.
    var isCached: Bool { get }
    
    /// Method that fetches a `UIImage` from the `url` property of a `ImageFetchable` object. It has two levels of caching - in memory and on disk
    ///
    /// - Parameter completion: Completion with the result. Executed on the main thread.
    func fetchPreview(withCompletion completion: @escaping (UIImage?) -> ())
    /// Method that downloads a `UIImage` from the `url` property of a `ImageFetchable` object. It fills the cache with the result and its a part of `fetchPreview(withCompletion:)`
    ///
    /// - Parameter completion: completion description
    func downloadImage(withCompletion completion: @escaping (UIImage?) -> ())
}

extension ImageFetchable {
    
    /// Name of local image that will be passed as a result from `fetchPreview(withCompletion:)` from `ImageFetchable` protocol in case the `url` is `nil`.
    public var dummyImageName: String? { nil }
    
    /// True when the current image is already in memory or on disk.
    public var isCached: Bool {
        guard inMemoryPreview == nil else { return true }
        if let imageURL = url {
            return ImageCachingKit.readImageForKey(imageURL.lastPathComponent) != nil
        } else {
            return UIImage(named: dummyImageName ?? "") != nil
        }
    }

    /// Method that fetches a `UIImage` from the `url` property of a `ImageFetchable` object. It has two levels of caching - in memory and on disk
    ///
    /// - Parameter completion: Completion with the result. Executed on the same thread as called if image is cached and async on the main thread if image has to be downloaded.
    public func fetchPreview(withCompletion completion: @escaping (UIImage?) -> ()) {
        guard let imageURL = url else {
            let dummyImage = UIImage(named: dummyImageName ?? "")
            inMemoryPreview = dummyImage
            completion(dummyImage)
            return
        }
        
        if let inMemoryImage = inMemoryPreview {
            completion(inMemoryImage)
            return
        }
        
        if let onDiskImage = ImageCachingKit.readImageForKey(imageURL.lastPathComponent) {
            inMemoryPreview = onDiskImage
            completion(onDiskImage)
            return
        }
        
        downloadImage(withCompletion: completion)
    }
    
    /// Method that downloads a `UIImage` from the `url` property of a `ImageFetchable` object. It fills the cache with the result and its a part of `fetchPreview(withCompletion:)`
    ///
    /// - Parameter completion: completion description
    public func downloadImage(withCompletion completion: @escaping (UIImage?) -> ()) {
        
        guard let imageURL = url else { DispatchQueue.main.async { completion(nil)}; return }
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: imageURL) { [weak self] (result, responce, error) in
            guard let rawData = result else { DispatchQueue.main.async { completion(nil)}; return }
            guard let image = UIImage(data: rawData) else { DispatchQueue.main.async { completion(nil)}; return }
            self?.inMemoryPreview = image
            DispatchQueue.main.async { completion(image) }
            _ = try? ImageCachingKit.saveImage(image, forKey: imageURL.lastPathComponent)
            session.finishTasksAndInvalidate()
        }
        task.resume()
    }
}
