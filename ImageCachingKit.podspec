#
# Be sure to run `pod lib lint ImageCachingKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ImageCachingKit'
  s.version          = '1.0.1'
  s.summary          = 'Image Caching Library for iOS written in Swift 5, that uses the filesystem as caching storage.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Image Caching Library for iOS written in Swift 5, that uses the filesystem as caching storage.

DiskCache is a file system level cache, that act as a dictionary [String: UIImage]. It works with one sub directory of NSCachesDirectory: NSCachesDirectory/ImageCachingKit for storing the cached images. The cleaning of the cache is managed by the operating system.

Build using Swift 5, XCode 11.4.1, supports iOS 10.0+
                       DESC

  s.homepage         = 'https://github.com/stoqn4opm/ImageCachingKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'stoqn4opm' => 'stoqn.stoqnov.93@gmail.com' }
  s.source           = { :git => 'https://github.com/stoqn4opm/ImageCachingKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'
  s.swift_versions = ['5.0']
  s.source_files = 'ImageCachingKit/**/*.{h,swift}'
  
  # s.resource_bundles = {
  #   'ImageCachingKit' => ['ImageCachingKit/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
