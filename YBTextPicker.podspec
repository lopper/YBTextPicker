Pod::Spec.new do |s|
    s.name = 'YBTextPicker'
    s.version = '1.0.0'
    s.license = { :type => "MIT", :file => "LICENSE.MD" }
 
    s.summary = 'Yet another text picker / selector written in swift 4.2.'
    s.homepage = 'https://github.com/lopper/YBTextPicker'
    s.author = { "YahyaBagia" => "" }
 
    s.source = { :git => 'https://github.com/lopper/YBTextPicker.git', :tag => s.version }
    s.source_files = 'Sources/**/*.swift'
 
    s.swift_version = '4.2'
 
    s.ios.deployment_target = '12.0'
    s.ios.resource_bundle = { 'YBTextPicker' => 'YBTextPicker/Assets' }
 
 
 end