# Uncomment the next line to define a global platform for your project
# platform :ios, ‘8.0’
use_frameworks!

target 'Bluestar' do

pod 'IQKeyboardManagerSwift'
pod ‘FMDB’



# Don’t delete below line of code is mandatory to build the pod
    post_install do |installer|
        installer.pods_project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['EXPANDED_CODE_SIGN_IDENTITY'] = ""
                config.build_settings['CODE_SIGNING_REQUIRED'] = "NO"
                config.build_settings['CODE_SIGNING_ALLOWED'] = "NO"
                config.build_settings['SWIFT_VERSION'] = '3.0'
            end
        end
    end
end


