platform :ios, '13.0'

target 'HaNoi360' do
  use_frameworks!

  pod 'SnapKit'
  pod 'IQKeyboardManagerSwift'
  pod 'Cosmos'
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'Toast-Swift'
  pod 'FSCalendar'

  firebase_version = '10.8.0'
  pod 'FirebaseCore', firebase_version
  pod 'FirebaseAuth', firebase_version
  pod 'FirebaseFirestore', firebase_version
  pod 'FirebaseFirestoreSwift', firebase_version
  pod 'Firebase/Storage', firebase_version

  pod 'SkeletonView'
  pod 'Kingfisher'
  pod 'UPCarouselFlowLayout'
  pod 'TTRangeSlider'
  pod 'lottie-ios'
  pod 'Cloudinary'
  pod 'Segmentio'
  pod 'RealmSwift'
  pod 'CHTCollectionViewWaterfallLayout'
  pod 'GoogleSignIn'

  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
        config.build_settings['SWIFT_VERSION'] = '5.9' # hoặc '5.10' nếu Xcode yêu cầu
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
