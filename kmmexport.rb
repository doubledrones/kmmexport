#!/usr/bin/env ruby

require 'rubygems'
require 'fileutils'
require 'plist'

class KMMExport

  KMM_FILE = "#{ENV["HOME"]}/Library/Preferences/Keyboard Maestro/Keyboard Maestro Macros.plist"

  def export
    kmm_file["MacroGroups"].each do |macro_group|
      create_macro_group_folder(macro_group)
      create_kmmacros_file(macro_group)
      export_macros(macro_group)
    end
  end

  private

    def kmm_file
      @kmm_file ||= Plist::parse_xml(KMM_FILE)
    end

    def create_macro_group_folder(macro_group)
      FileUtils.mkdir_p "macro_groups/#{macro_group["Name"]}"
    end

    def create_kmmacros_file(macro_group, macro = nil)
      if macro
        file_name = "macro_groups/#{macro_group["Name"]}/#{macro["Name"]}"
      else
        file_name = "macro_groups/#{macro_group["Name"]}"
      end
      File.open("#{file_name}.kmmacros", 'w') { |f| f.write([macro_group].to_plist) }
    end

    def export_macros(macro_group)
      macros = macro_group["Macros"]
      group  = macro_group.delete_if { |k,v| k == "Macros" }
      macros.each do |macro|
        next unless macro["Name"] # TODO notify
        group["Macros"] = [macro]
        create_kmmacros_file(group, macro)
      end
    end

end

kmmexport = KMMExport.new
kmmexport.export
