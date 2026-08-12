#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_native_ad.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_native_ad'
  s.version          = '0.0.1'
  s.summary          = 'Flutter Native Ads Plugin.'
  s.description      = <<-DESC
Flutter Native Ads Plugin is Allow Show All Types of Ads in One Package.
                       DESC
  s.homepage         = 'https://github.com/Khuntarpit/flutter_native_ad'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'Google-Mobile-Ads-SDK', '~> 13.3.0'
  s.dependency 'google_mobile_ads'
  s.platform = :ios, '13.0'
  s.static_framework = true

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
