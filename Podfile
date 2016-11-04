# Uncomment this line to define a global platform for your project
platform :ios, '10.0'
use_frameworks!

target 'PupCare' do
pod 'Parse', '~> 1.13'
pod 'FBSDKCoreKit', '~> 4.11.0'
pod 'FBSDKLoginKit', '~> 4.11.0'
pod 'FBSDKShareKit', '~> 4.11.0'
pod 'ParseFacebookUtilsV4', '~> 1.11.1'
pod 'Kingfisher', '~> 3.0'
pod 'Alamofire', '~> 4.0'
pod 'Gloss', '~> 1.1'
end

target 'PupCareTests' do
    pod 'Parse', '~> 1.13'
    pod 'FBSDKCoreKit', '~> 4.11.0'
    pod 'FBSDKLoginKit', '~> 4.11.0'
    pod 'FBSDKShareKit', '~> 4.11.0'
    pod 'ParseFacebookUtilsV4', '~> 1.11.1'
    pod 'Kingfisher', '~> 3.0'
    pod 'Alamofire', '~> 4.0'
    pod 'Gloss', '~> 1.1'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
          config.build_settings['SWIFT_VERSION'] = '3.0'
      end
  end
end
