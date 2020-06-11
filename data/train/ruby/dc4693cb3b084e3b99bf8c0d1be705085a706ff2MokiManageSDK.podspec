
Pod::Spec.new do |s|
  s.name         = "MokiManageSDK"
  s.version      = "1.0.0-rc1"
  s.summary      = "Integrate your application with MokiManage."
  s.description  = <<-DESC
                    Using this SDK your application can integrate with [MokiManage](http://MokiManage.com/).
                    This will help you monitor the applications environment like:
                    * location
                    * network connectivity
                    * battery charge
                    * memory usage
                    * etc.
                    
                    This will also allow you to manage the settings of your application remotely.
                   DESC
  s.homepage     = "https://github.com/MokiMobility/MokiManageSDK-iOS"
  
  s.license      = {
    :type => 'Commercial',
    :text => <<-LICENSE
              All text and design is copyright © 2013 MokiMobility

              All rights reserved.

              https://mokimobility.com/
    LICENSE
  }

  s.author       = { "MokiMobility" => "info@mokimobility.com" }
  s.source       = { :git => "https://github.com/MokiMobility/MokiManageSDK-iOS.git", :tag => "1.0.0-rc1" }

  s.platform     = :ios, '5.0'

  s.source_files = '*.{h,m,mm,c,cpp}'
  s.resources = "Buttons/*.png"
  s.preserve_paths = "libMokiManage.a"
  s.library = 'MokiManage'
  s.frameworks = 'ExternalAccessory', 'CoreTelephony', 'CoreLocation', 'SystemConfiguration', 'Foundation', 'CoreGraphics'
  s.requires_arc = true
  s.xcconfig = { 'LIBRARY_SEARCH_PATHS' => '"$(PODS_ROOT)/MokiManageSDK"' }

  s.dependency 'AFNetworking', '~> 1.3.1'
end
