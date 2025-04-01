Pod::Spec.new do |spec|
  spec.name          = 'iOSVehicleConnectSDK'
  spec.version       = '1.0.0'
  spec.license       = { :type => 'BSD' }
  spec.homepage      = 'https://github.com/eclipse-ecsp/iOSVehicleConnectSDK'
  spec.authors       = { 'Vishwajeet-Kumar32' => 'Vishwajeet.kumar32@harman.com' }
  spec.summary       = 'This is the vehicle connect SDK to access vehicle profile and remote operations'
  spec.source        = { :git => 'https://github.com/eclipse-ecsp/iOSVehicleConnectSDK.git', :tag => 'v1.0.0' }
 
  spec.swift_version = '5.0'

  spec.source_files  = 'iOSVehicleConnectSDK/*.swift'
  spec.framework     = 'SystemConfiguration'

end