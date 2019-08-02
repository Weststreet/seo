#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'soe'
  s.version          = '0.0.1'
  s.summary          = 'A new flutter plugin project.'
  s.description      = <<-DESC
A new flutter plugin project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'

  s.preserve_paths = 'TAISDK.framework'
  s.xcconfig = { 'OTHER_LDFLAGS' => '-framework TAISDK' }
  s.vendored_frameworks = 'TAISDK.framework'

  s.preserve_paths = 'lame.framework'
  s.xcconfig = { 'OTHER_LDFLAGS' => '-framework lame' }
  s.vendored_frameworks = 'lame.framework'

  s.ios.deployment_target = '8.0'

  s.static_framework = true
  s.requires_arc = true
end
