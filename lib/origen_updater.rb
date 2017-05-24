require 'origen'
require_relative '../config/application.rb'

# Ensure the app always has the latest version of the updater scripts
app_fix_my_workspace = "#{Origen.root}/bin/fix_my_workspace"
if File.exist?(app_fix_my_workspace)
  $_fix_my_workspace_version_check = true
  load app_fix_my_workspace
end

if $_fix_my_workspace_version != Origen.app!.version
  master_fix_my_workspace = File.expand_path('../../bin/fix_my_workspace', __FILE__)
  FileUtils.mkdir_p "#{Origen.root}/bin" unless File.exist?("#{Origen.root}/bin")
  # When running standalone
  unless master_fix_my_workspace == app_fix_my_workspace
    FileUtils.cp master_fix_my_workspace, app_fix_my_workspace
  end
end
