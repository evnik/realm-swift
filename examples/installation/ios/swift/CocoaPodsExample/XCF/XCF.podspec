Pod::Spec.new do |s|
  s.name             = 'XCF'
  s.version          = '0.0.1'
  s.summary          = 'XCFramework with RealmSwift dependency'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
  DESC

  s.homepage         = 'https://github.com/realm/realm-swift.git'
  s.author           = { 'Eugene Berdnikov' => 'eugene@level.co' }
  s.source           = { :git => 'https://github.com/realm/realm-swift.git', :branch => 'master' }
  s.ios.deployment_target = '11.0'

  if ENV["FRAMEWORK_BUILD"]
    s.source_files = 'Sources/**/*'
  else
    s.vendored_frameworks = 'XCF.xcframework'
  end

  s.dependency 'RealmSwift', '10.33.0'
end
