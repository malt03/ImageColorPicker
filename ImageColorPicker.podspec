#
# Be sure to run `pod lib lint ImageColorPicker.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "ImageColorPicker"
  s.version          = "0.1.1"
  s.summary          = "Easy to pick a color from UIImage."

  s.description      = <<-DESC
You can pick a color from UIImage and CGPoint.
                       DESC

  s.homepage         = "https://github.com/malt03/ImageColorPicker"
  s.license          = 'MIT'
  s.author           = { "Koji Murata" => "koji.murata@dena.com" }
  s.source           = { :git => "https://github.com/malt03/ImageColorPicker.git", :tag => s.version.to_s }

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
end
