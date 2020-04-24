Pod::Spec.new do |s|
    # 1
    s.platform = :ios
    s.ios.deployment_target = '9.0'
    s.name = "PicUPSDK"
    s.summary = "PicUPSDK"
    s.requires_arc = true
    
    # 2
    s.version = "1.1.0"
    
    # 3
    s.license = { :type => 'MIT', :file => 'LICENSE' }
    
    # 4 - Replace with your name and e-mail address
    s.author = { 'test' => 'test@gmail.com' }
    
    # 5 - Replace this URL with your own GitHub page's URL (from the address bar)
    s.homepage = 'https://github.com/PicupMobile/IOS.PicupSDK'
    
    # 6 - Replace this URL with your own Git URL from "Quick Setup"
    s.source = { :git => 'https://github.com/PicupMobile/IOS.PicupSDK.git', :tag => s.version.to_s }
    
    # 7
    s.framework = 'UIKit'
    s.framework = 'Foundation'
    s.dependency 'Alamofire', '4.9.1'
    
    # 8
#    s.source_files  = 'Sources/**/*.{swift}'
    s.public_header_files = "SDKFramework/PicUPSDK.framework/Headers/*.h"
    s.source_files = "SDKFramework/PicUPSDK.framework/Headers/*.h"
    s.vendored_frameworks = "SDKFramework/PicUPSDK.framework"
    
    # 9
#    s.resources = "IOS.PicupSDK/**/*.{png,jpeg,jpg,storyboard,xib,xcassets}"
    
    # 10
    s.swift_version = "4.2"
end

