//
//  ImageCachingKit.swift
//  ImageCachingKit
//
//  Created by Stoyan Stoyanov on 27/05/2019.
//  Copyright © 2019 Stoyan Stoyanov. All rights reserved.
//

import UIKit

// MARK: - Configuration

extension ImageCachingKit {
    
    fileprivate static var imagesCacheDirectoryName: String { return "ImageCachingKit" }
}

// MARK: - Throwable Errors

extension ImageCachingKit {
    
    /// All possible errors that can occur with `ImageCachingKit`.
    ///
    /// - saveFailed: Occurs when trying to save image in place where you have no permission.
    public enum Error: Swift.Error {
        
        /// Occurs when trying to save image in place where you have no permission.
        case saveFailed(String)
    }
}

// MARK: - Class Definition

/// ImageCachingKit is a file system level cache, that act as a dictionary `[String: UIImage]`.
///
/// It works with one sub directory of `NSCachesDirectory`:
/// ```
/// NSCachesDirectory/ImageCachingKit
/// ```
/// for storing the cached images. The cleaning of the cache is managed by the operating system.
public struct ImageCachingKit { }

// MARK: - Write Methods

extension ImageCachingKit {
    
    /// Saves image inside 'ImageCachingKit' subdirectory or throws `ImageCachingError` if error occured.
    ///
    /// - Parameters:
    ///   - image: pass here the image that you want cached.
    ///   - key: pass here the key under which you want this image cached. (example: the image name).
    /// - Throws: error in case the save operation fails.
    public static func saveImage(_ image: UIImage, forKey key: String) throws {
        return try save(image, forKey: key, in: imagesCacheDirectory)
    }
    
    private static func save(_ image: UIImage, forKey key: String, in url: URL?) throws {
        guard var imagesDirectory = url else { throw Error.saveFailed("[ImageCachingKit] `saveImage(image:, forKey:)` failed. reason: No imagesCacheDirectory found.") }
        imagesDirectory.appendPathComponent(key)
        
        guard let data = image.pngData() else { throw Error.saveFailed("[ImageCachingKit] `saveImage(image:, forKey:)` failed. reason: image can't be represented as PNG.") }
        let success = FileManager.default.createFile(atPath: imagesDirectory.absoluteString, contents: data, attributes: nil)
        if !success {
            throw Error.saveFailed("[ImageCachingKit] `saveImage(image:, forKey:)` failed. reason: write failed.")
        }
    }
}

// MARK: - Read Methods

extension ImageCachingKit {

    /// Returns a cached image or nil if image can't be found or error occured.
    ///
    /// - Parameter key: the key under which you have cached the image.
    /// - Returns: the stored image, if found under this key.
    public static func readImageForKey(_ key: String) -> UIImage? {
        return readForKey(key, in: imagesCacheDirectory)
    }
    
    private static func readForKey(_ key: String, in url: URL?) -> UIImage? {
        guard var imagesDirectory = url else { return nil }
        imagesDirectory.appendPathComponent(key)
        
        guard let data = FileManager.default.contents(atPath: imagesDirectory.absoluteString) else { return nil }
        let image = UIImage(data: data)
        return image
    }
}

// MARK: - Creating/Getting Cache Directiories

extension ImageCachingKit {
    
    static var imagesCacheDirectory: URL? { return createCacheSubdirectoryNamed(imagesCacheDirectoryName) }
    
    private static func createCacheSubdirectoryNamed(_ name: String) -> URL? {
        guard let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first else { return nil }
        guard var url = URL(string: path) else { return nil }
        url.appendPathComponent(name)
        
        do {
            try FileManager.default.createDirectory(atPath: url.absoluteString, withIntermediateDirectories: true, attributes: nil)
            return url
        } catch {
            return nil
        }
    }
}
