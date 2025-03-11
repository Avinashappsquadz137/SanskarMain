platform :ios, '12.0'

target 'Sanskar' do
  use_frameworks!

  # Pods for Total Bhakti.
   pod 'Google/SignIn'
  pod 'Alamofire'
  pod 'FacebookCore'
  pod 'FacebookLogin'
  pod 'MICountryPicker'
  pod 'IQKeyboardManagerSwift'
  pod 'SlideMenuControllerSwift'
  pod 'SDWebImage', '~> 4.0'
  pod 'FSPagerView'
  pod 'AAPlayer'
  pod 'ReadMoreTextView'
  pod 'CircleProgressView', '~> 1.0'
  pod 'OTPFieldView'
  pod 'MMPlayerView'
  pod 'CLTypingLabel'
  pod 'GTMOAuth2'
  pod 'google-cast-sdk', '~> 4.6.1'
  pod 'CountryPickerView'
  pod 'ExpandableLabel'
  pod 'PaddingLabel', '1.1'
  pod 'razorpay-pod', '1.2.5'
  pod 'FittedSheets'
  pod 'DropDown'
  pod 'Fabric', '~> 1.10.2'
  pod 'Crashlytics', '~> 3.14.0'
  pod 'CryptoSwift', '~> 1.0'
  pod 'Firebase/Core'
  pod 'Firebase/DynamicLinks'
  pod 'Firebase/Database'
  pod 'Firebase/Storage'
  pod 'Firebase/Auth'
  pod 'Firebase/Messaging'
  pod 'MarqueeLabel'
  pod 'YouTubePlayer'
  pod 'YoutubePlayer-in-WKWebView'
  pod 'youtube-ios-player-helper'
  pod 'VerticalCardSwiper'
pod 'Google-Mobile-Ads-SDK'
  pod 'HyperSDK', '2.1.31'
 pod 'nanopb', '~> 2.30907.0'
 
  pod 'GoogleAppMeasurement'
  pod 'PromisesObjC'

  
end

post_install do |installer|
  installer.generated_projects.each do |project|
    project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
      end
    end
  end

  fuse_path = "./Pods/HyperSDK/Fuse.rb"
  clean_assets = true # Pass true to re-download all the assets
  if File.exist?(fuse_path)
    system("ruby", fuse_path.to_s, clean_assets.to_s)
  end
end
