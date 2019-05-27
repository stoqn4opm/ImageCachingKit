# ImageCachingKit

![](https://img.shields.io/badge/version-1.0-brightgreen.svg)

Image Caching Library for iOS written in Swift 5, that uses the filesystem as caching storage.

`DiskCache` is a file system level cache, that act as a dictionary `[String: UIImage]`. It works with one sub directory of `NSCachesDirectory`: `NSCachesDirectory/ImageCachingKit` for storing the cached images. The cleaning of the cache is managed by the operating system.

Build using Swift 5, XCode 10.2, supports iOS 10.0+

# Usage

Import the `ImageCachingKit` framework to your file.
```swift
import ImageCachingKit
```

Writing:
```swift
/// Saves image inside 'ImageCachingKit' subdirectory or throws `ImageCachingError` if error occured.
///
/// - Parameters:
/// - image: pass here the image that you want cached.
/// - key: pass here the key under which you want this image cached. (example: the image name).
/// - Throws: error in case the save operation fails.
ImageCachingKit.saveImage(_ image: UIImage, forKey key: String) throws
```

Reading:

```swift
/// Returns a cached image or nil if image can't be found or error occured.
///
/// - Parameter key: the key under which you have cached the image.
/// - Returns: the stored image, if found under this key.
ImageCachingKit.readImageForKey(_ key: String) -> UIImage?
```

# Installation

### Carthage Installation

1. In your `Cartfile` add `github "stoqn4opm/ImageCachingKit"`
2. Link the build framework with the target in your XCode project

For detailed instructions check the official Carthage guides [here](https://github.com/Carthage/Carthage)

### Manual Installation

1. Download the project and build the shared target called `ImageCachingKit`
2. Add the product in the list of "embed frameworks" list inside your project's target or create a work space with ImageCachingKit and your project and link directly the product of ImageCachingKit's target to your target "embed frameworks" list

# Licence

The framework is licensed under MIT licence. For more information see file `LICENCE`
