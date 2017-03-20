#
# Be sure to run `pod lib lint LiveObjectTracer.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'LiveObjectTracer'
  s.version          = '0.1.1'
  s.summary          = 'Library to notice you when the NSObject or subclass object was deallocated'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
I was tried to let some actions when the object was deallocated.
LiveObjectTracer is one of the solution for it.

It trigger delegate method when the NSObject or subclass object was deallocated.
The object includes all of the NSObject subclasses,
your made and third party made and Apple made.
You can use this library to any situations.

I got core concept of LiveObjectTracer from
http://stackoverflow.com/questions/14957382/want-to-perform-action-when-weak-ivar-is-niled.
Thank you stackoverflow and users!
                       DESC

  s.homepage         = 'https://github.com/wagyu298/LiveObjectTracer'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'wagyu298' => 'wagyu298@gmail.com' }
  s.source           = { :git => 'https://github.com/wagyu298/LiveObjectTracer.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/wagyu298'

  s.ios.deployment_target = '8.0'

  s.source_files = 'LiveObjectTracer/Classes/**/*'
  
  # s.resource_bundles = {
  #   'LiveObjectTracer' => ['LiveObjectTracer/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
