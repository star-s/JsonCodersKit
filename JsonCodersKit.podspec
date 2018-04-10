#
# Be sure to run `pod lib lint JsonCodersKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'JsonCodersKit'
  s.version          = '0.6.1'
  s.summary          = 'Library for encode objects to JSON compliant NSDictionary and vice versa'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
NSCoder subclasses for decode/encode objects conforming NSCoding protocol to JSON compliant NSDictionary
                       DESC

  s.homepage         = 'https://github.com/star-s/JsonCodersKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Sergey Starukhin' => 'star.s@me.com' }
  s.source           = { :git => 'https://github.com/star-s/JsonCodersKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.9'
  s.watchos.deployment_target = '2.0'
  s.tvos.deployment_target = '9.0'

  s.source_files = 'JsonCodersKit/Classes/**/*'
  
  # s.resource_bundles = {
  #   'JsonCodersKit' => ['JsonCodersKit/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.module_map = 'JsonCodersKit/JsonCodersKit.modulemap'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
