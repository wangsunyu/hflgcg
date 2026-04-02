#!/usr/bin/env ruby
# 自动将 Swift 文件添加到 Xcode 项目的脚本

require 'xcodeproj'

project_path = '/Users/wsy/Desktop/code/iOS项目/合肥理工_副本4/HFITCampus/HFITCampus.xcodeproj'
project = Xcodeproj::Project.open(project_path)

# 获取主 target
target = project.targets.first

# 获取主 group
main_group = project.main_group['HFITCampus']

# 要添加的文件列表
files_to_add = [
  'HFITCampus/App/AppState.swift',
  'HFITCampus/Core/Config/APIConfig.swift',
  'HFITCampus/Core/Models/UserManager.swift',
  'HFITCampus/Core/Network/NetworkMonitor.swift',
  'HFITCampus/Core/Network/NetworkService.swift',
  'HFITCampus/Core/Services/CookieManager.swift',
  'HFITCampus/Core/Services/URLBuilder.swift',
  'HFITCampus/UI/Theme/AppTheme.swift'
]

files_to_add.each do |file_path|
  file_ref = main_group.new_reference(file_path)
  target.add_file_references([file_ref])
  puts "Added: #{file_path}"
end

project.save

puts "\n✅ All files added to Xcode project successfully!"
