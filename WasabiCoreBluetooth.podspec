#
# Be sure to run `pod lib lint WasabiCoreBluetooth.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "WasabiCoreBluetooth"
  s.version          = "0.1.0"
  s.summary          = "CoreBluetooth Extensions"

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!
  s.description      = <<-DESC
Provides a wrapper around CoreBluetooth objects used for BLE Central tasks allowing multiple
delegates to be assigned to centrals and discovered peripherals.
                       DESC

  s.homepage         = "https://github.com/rothmichaels/WasabiCoreBluetooth"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'Apache 2.0'
  s.author           = { "Roth Michaels" => "roth@rothmichaels.us" }
  s.source           = { :git => "https://github.com/rothmichaels/WasabiCoreBluetooth.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'WasabiCoreBluetooth/**/*'
  # s.resource_bundles = {
  #   'WasabiCoreBluetooth' => ['Pod/Assets/*.png']
  # }

  s.public_header_files = 'WasabiCoreBluetooth/Headers/Public/*.h'
  s.frameworks = 'CoreData'
  # s.dependency 'AFNetworking', '~> 2.3'
end
