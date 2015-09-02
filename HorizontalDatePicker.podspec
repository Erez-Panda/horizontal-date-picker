#
# Be sure to run `pod lib lint HorizontalDatePicker.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "HorizontalDatePicker"
  s.version          = "0.1.3"
  s.summary          = "Horizontal date picker for iOS in Swift."
  s.description      = <<-DESC
                       Simple, configurable date picker that scrolles horizontally. Written is Swift.

                       * Markdown format.
                       * Don't worry about the indent, we strip it!
                       DESC
  s.homepage         = "https://github.com/Erez-Panda/horizontal-date-picker"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Erez Haim" => "erez@livemed.co" }
  s.source           = { :git => "https://github.com/Erez-Panda/horizontal-date-picker.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resources = ["classes/DayView.xib"]
  s.resource_bundles = {
    'HorizontalDatePicker' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
