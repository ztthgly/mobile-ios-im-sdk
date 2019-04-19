#
# Be sure to run `pod lib lint ZT_IM_SDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ZT_IM_SDK'
  s.version          = '1.2.0'
  s.summary          = '中通在线客服'

  s.homepage         = 'https://github.com/ztthgly/mobile-ios-im-sdk'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Jialiang' => 'jialiangnull@gmail.com' }
  s.source           = { :git => 'https://github.com/ztthgly/mobile-ios-im-sdk.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'
  
  s.subspec 'SDKLib' do |ss|
      ss.source_files = 'ZT_IM_SDK/Classes/SDKLib/**/*.{h}'
      ss.frameworks = 'Foundation', 'CoreMedia', 'AVFoundation', 'CFNetwork', 'Security'
      ss.libraries = 'icucore', 'curses'
      ss.vendored_libraries = 'ZT_IM_SDK/Classes/SDKLib/libZT_IM_Lib.a'
      ss.xcconfig     = {'OTHER_LDFLAGS' => '-ObjC'}
  end
  
  s.subspec 'SDKKit' do |ss|
      ss.source_files = 'ZT_IM_SDK/Classes/SDKKit/**/*.{h,m}'
      ss.requires_arc = true
      ss.resource_bundles = {
          'ZT_IM_SDK' => ['ZT_IM_SDK/Classes/SDKKit/Assets/*.xcassets']
      }
      ss.resource = 'ZT_IM_SDK/Classes/SDKKit/**/*.{xib,storyboard,plist}'
      ss.dependency 'ZT_IM_SDK/SDKLib'
      ss.dependency 'YYWebImage'
      ss.dependency 'ESPictureBrowser'
  end

end
