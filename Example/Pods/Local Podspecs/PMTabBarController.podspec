Pod::Spec.new do |s|
  s.name             = "PMTabBarController"
  s.version          = "0.9.0"
  s.summary          = "PMTabBarController is a subclass of UITabBarController that replaces the conventional tab bar with a circularly scrolling scroll view of any number of tab bar icon views."
  s.homepage         = "https://github.com/pm-dev/#{s.name}"
  s.license          = 'MIT'
  s.author           = { "Peter Meyers" => "petermeyers1@gmail.com" }
  s.source           = { :git => "https://github.com/pm-dev/#{s.name}.git", :tag => s.version.to_s }
  s.platform         = :ios, '7.0'
  s.ios.deployment_target = '7.0'
  s.requires_arc     = true
  s.source_files     = 'Classes/**/*.{h,m}'
  s.ios.exclude_files = 'Classes/osx'
  s.osx.exclude_files = 'Classes/ios'
  s.public_header_files = 'Classes/**/*.h'
  s.frameworks       = 'Foundation', 'CoreGraphics', 'UIKit'
  s.dependency 'PMUtils'
  s.dependency 'PMCircularCollectionView'
end
