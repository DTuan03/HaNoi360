# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

target 'HaNoi360' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for HaNoi360

pod 'SnapKit'
pod 'IQKeyboardManagerSwift'
pod 'Cosmos'
pod 'RxSwift'
pod 'RxCocoa'
pod 'Toast-Swift'
pod 'FSCalendar'
pod 'FirebaseCore', '10.15.0'
pod 'FirebaseAuth', '10.15.0'
pod 'FirebaseFirestore', '10.15.0'
pod 'FirebaseFirestoreSwift', '10.15.0'
pod 'SkeletonView'
pod 'Kingfisher'
pod "UPCarouselFlowLayout"
pod 'TTRangeSlider'
pod 'lottie-ios'
pod 'Cloudinary'
pod 'pickle'
post_install do |installer|
  installer.pods_project.targets.each do |target|
	target.build_configurations.each do |config|
      	config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
    end
    if target.name == 'BoringSSL-GRPC'
      target.source_build_phase.files.each do |file|
        if file.settings && file.settings['COMPILER_FLAGS']
          flags = file.settings['COMPILER_FLAGS'].split
          flags.reject! { |flag| flag == '-GCC_WARN_INHIBIT_ALL_WARNINGS' }
          file.settings['COMPILER_FLAGS'] = flags.join(' ')
        end
      end
    end
  end
end

end
