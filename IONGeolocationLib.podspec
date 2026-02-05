require 'json'
package = JSON.parse(File.read(File.join(__dir__, 'package.json')))

Pod::Spec.new do |spec|
  spec.name                   = package['name']
  spec.version                = package['version']

  spec.summary                = package['description']
  spec.description            = 'A Swift library for iOS that provides simple, reliable access to device GPS capabilities. Get location data, monitor position changes, and manage location services with a clean, modern API.'

  spec.homepage               = 'https://github.com/ionic-team/ion-ios-geolocation'
  spec.license                = { :type => package['license'], :file => 'LICENSE' }
  spec.author                 = { package['author'] => package['email'] }
  
  spec.source                 = { :http => "https://github.com/ionic-team/ion-ios-geolocation/releases/download/#{spec.version}/IONGeolocationLib.zip", :type => "zip" }
  spec.vendored_frameworks    = "IONGeolocationLib.xcframework"

  spec.ios.deployment_target  = '14.0'
  spec.swift_versions         = ['5.0', '5.1', '5.2', '5.3', '5.4', '5.5', '5.6', '5.7', '5.8', '5.9']
end
