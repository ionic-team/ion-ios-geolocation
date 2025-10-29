Pod::Spec.new do |spec|
  spec.name                   = 'IONGeolocationLib'
  spec.version                = '2.0.0'

  spec.summary                = 'A native iOS library for Geolocation authorisation and monitoring.'
  spec.description            = 'A Swift library for iOS that provides simple, reliable access to device GPS capabilities. Get location data, monitor position changes, and manage location services with a clean, modern API.'

  spec.homepage               = 'https://github.com/ionic-team/IONGeolocationLib-iOS'
  spec.license                = { :type => 'MIT', :file => 'LICENSE' }
  spec.author                 = { 'OutSystems Mobile Ecosystem' => 'rd.mobileecosystem.team@outsystems.com' }
  
  spec.source                 = { :http => "https://github.com/ionic-team/IONGeolocationLib-iOS/releases/download/#{spec.version}/IONGeolocationLib.zip", :type => "zip" }
  spec.vendored_frameworks    = "IONGeolocationLib.xcframework"

  spec.ios.deployment_target  = '14.0'
  spec.swift_versions         = ['5.0', '5.1', '5.2', '5.3', '5.4', '5.5', '5.6', '5.7', '5.8', '5.9']
end