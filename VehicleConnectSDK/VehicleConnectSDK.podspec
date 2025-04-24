#
#  Be sure to run `pod spec lint VehicleConnectSDK.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  spec.name         = "VehicleConnectSDK"
  spec.version      = "1.0.4"
  spec.summary      = "VehicleConnectSDK provide API interface for User Management and Remote Operation."
  spec.description  = <<-DESC
  VehicleConnectSDK provide API interface for Remote Operation, User Authentication, Vehicle Profile, Vehicle Association. So remote operations mobile apps can be designed by using the VehcleConnectSDK.
                   DESC

  spec.homepage     = "https://github.com/eclipse-ecsp/iOSVehicleConnectSDK"
  spec.license      = { :type => "Apache", :file => "LICENSE" }
  spec.author       = { "Vishwajeet-Kumar32" => "vishwajeetkumarji@gmail.com" }
  
  # spec.platform     = :ios
  # spec.platform     = :ios, "5.0"

  #  When using multiple platforms
   spec.ios.deployment_target = "15.0"
  # spec.osx.deployment_target = "10.7"
  # spec.watchos.deployment_target = "2.0"
  # spec.tvos.deployment_target = "9.0"
  # spec.visionos.deployment_target = "1.0"


    spec.source       = { :git => "https://github.com/eclipse-ecsp/iOSVehicleConnectSDK.git", :tag => "#{spec.version}" }
    spec.source_files  = "VehicleConnectSDK/**/*.swift"
    spec.exclude_files = "VehicleConnectSDK/VehicleConnectSDKTests/**/*Tests.swift"
    
    spec.requires_arc = true
    spec.dependency "AppAuth"
    spec.swift_versions = ["5.0"]
    
    # Test specs
    # spec.test_spec 'Tests' do |test_spec|
        # test_spec.source_files = 'VehicleConnectSDK/VehicleConnectSDKTests/**/*.{swift,h,m}'
    # end

end
