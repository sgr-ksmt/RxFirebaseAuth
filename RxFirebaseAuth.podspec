Pod::Spec.new do |s|
  s.name             = "RxFirebaseAuth"
  s.version          = "2.4"
  s.summary          = "Combination of RxSwift and Firebase/Auth"
  s.homepage         = "https://github.com/sgr-ksmt/RxFirebaseAuth"
  s.license          = 'MIT'
  s.author           = { "Suguru Kishimoto" => "melodydance.k.s@gmail.com" }
  s.source           = { :git => "https://github.com/sgr-ksmt/RxFirebaseAuth.git", :tag => s.version.to_s }
  s.platform         = :ios, '9.0'
  s.requires_arc     = true
  s.source_files     = "Sources/**/*"
  s.static_framework = true
  s.swift_version    = "5.0"
  s.dependency "Firebase/Auth", "~> 6.0"
  s.dependency "RxSwift", "~> 5.0"
end
