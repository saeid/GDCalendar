Pod::Spec.new do |s|
s.name             = "GDCalendar"
s.version          = "2.0.3"
s.summary          = "Calendar with RTL language support"
s.homepage         = "https://github.com/saeid/GDCalendar"
s.license          = 'MIT'
s.author           = { "Saeid Basirnia" => "saeid.basirniaa@gmail.com" }
s.source           = { :git => "https://github.com/saeid/GDCalendar.git", :tag => "2.0.3"}

s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.0' }
s.platform     = :ios
s.ios.deployment_target  = '9.0'
s.requires_arc = true
s.swift_version = '4.2'
s.source_files = 'source/GDCalendar/**/*.{swift}'
s.frameworks = 'UIKit'

end


