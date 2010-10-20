#!/usr/bin/env ruby

require 'rubygems'
require 'fileutils'
require 'plist'

file = Plist::parse_xml('Keyboard Maestro Macros.plist')

file["MacroGroups"].each do |marco_group|
  FileUtils.mkdir_p "macro_groups/#{marco_group["Name"]}"
  File.open("macro_groups/#{marco_group["Name"]}.kmmacros", 'w') {|f| f.write([marco_group].to_plist) }
  group_macros = marco_group["Macros"]
  group = marco_group.delete_if { |key, value| key == "Macros" }
  group_macros.each do |macro|
    next unless macro["Name"]
    group["Macros"] = [macro]
    File.open("macro_groups/#{marco_group["Name"]}/#{macro["Name"]}.kmmacros", 'w') {|f| f.write([group].to_plist) }
  end
end
