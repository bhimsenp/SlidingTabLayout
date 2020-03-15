#
# Be sure to run `pod lib lint SlidingTabLayout.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SlidingTabLayout'
  s.version          = '0.1.1'
  s.summary          = 'Sliding Tab Layout for iOS'

  s.description      = <<-DESC
SlidingTabLayout is a library that can be used to add paging view controllers accompanied with Tabs at the top. You can place tab items in header separately from the content views as well as in a single view. It also allows to layout tabs is two modes:
1. Fixed (Used for small number of items): All tab items will be spread equally in a container with width equal to screen
2. Free (User for large number of items): All tab items will be have given hardcoded width and be scrollable horizontally.
                       DESC

  s.homepage         = 'https://github.com/bhimsenp/SlidingTabLayout'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Bhimsen Padalkar' => 'bhim.padalkar@gmail.com' }
  s.source           = { :git => 'https://github.com/bhimsenp/SlidingTabLayout.git', :tag => s.version.to_s }
  s.swift_versions	 = ['4.0', '5.0']
  s.ios.deployment_target = '9.0'

  s.source_files = 'SlidingTabLayout/Classes/**/*'
end
