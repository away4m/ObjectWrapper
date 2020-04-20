# frozen_string_literal: true

Pod::Spec.new do |s|
  s.name             = 'ObjectWrapper'
  s.version          = '0.1.0'
  s.summary          = 'Library for wrapping Swift value types and allowing to access members using with dynamicMemberLookup'

  s.description      = <<-DESC
  Seamlessly interop with Swift value types and parses JSON string. It uses enum to wrap Swift primitive types. It includes fail-safe functions to extract values.
  DESC

  s.homepage         = 'https://github.com/away4m/ObjectWrapper'

  s.license          = { type: 'MIT', file: 'LICENSE' }
  s.author           = { 'alikiran' => 'away4m@gmail.com' }
  s.source           = { git: 'https://github.com/away4m/ObjectWrapper.git', tag: s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'
  s.swift_version = '5.0'
  s.source_files = 'ObjectWrapper/Classes/**/*'
end
