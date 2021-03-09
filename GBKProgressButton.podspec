Pod::Spec.new do |s|
  s.name             = 'GBKProgressButton'
  s.version          = '0.1.7'
  s.summary          = 'GBKProgressButton is a button which transforms to spinner or progress bar'
  s.homepage         = 'https://gitlab.gbksoft.net/gbksoft-mobile-department/ios/gbkprogressbutton.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Roman Mizin' => 'mizin.re@gbksoft.com' }
  s.source           = { :git => 'https://gitlab.gbksoft.net/gbksoft-mobile-department/ios/gbkprogressbutton.git', :tag => s.version.to_s }
  s.ios.deployment_target = '12.0'
  s.swift_version = '5.1'
  s.source_files = 'GBKProgressButton/**/*'
end
