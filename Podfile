platform :ios, '10.0'
use_frameworks!

target 'MakeUp App' do
	pod 'SwiftyJSON'
	pod 'Firebase'
  	pod 'FirebaseAuth'
 	pod 'FirebaseDatabase'
	pod 'FBSDKCoreKit'
	pod 'FBSDKLoginKit'
	pod 'FBSDKShareKit'
	pod 'FacebookLogin'
   	pod 'Alamofire', '~> 4.4'
	pod "youtube-ios-player-helper", "~> 0.1.4"
	pod 'RealmSwift'


	post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
    end
  end
end
end 
