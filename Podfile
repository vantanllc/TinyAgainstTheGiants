source 'https://github.com/CocoaPods/Specs.git'
platform :ios, "10.0"

use_frameworks!

def testing_pods
pod 'Quick'
pod 'Nimble'
end

target 'TinyAgainstTheGiants' do
pod 'Google-Mobile-Ads-SDK'

target 'TinyAgainstTheGiantsTests' do
inherit! :search_paths
testing_pods
pod 'Google-Mobile-Ads-SDK'
end
end

