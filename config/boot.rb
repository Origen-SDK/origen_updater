# This file is used to boot your plugin when it is running in standalone mode
# from its own workspace - i.e. when the plugin is being developed.
#
# It will not be loaded when the plugin is imported by a 3rd party app - in that
# case only lib/origen_updater.rb is loaded.
#
# Therefore this file can be used to load anything extra that you need to boot
# the development environment for this app. For example, this is typically used
# to load some additional test classes to use your plugin APIs so that they can
# be tested and/or interacted with in the console.
require "origen_updater"

module OrigenUpdaterDev
  # Example of how to explicitly require a file
  # require "origen_updater_dev/my_file"
    
  # Load all files in the lib/origen_updater_dev directory.
  # Note that there is no problem from requiring a file twice (Ruby will ignore
  # the second require), so if you have a file that must be required first, then
  # explicitly require it up above and then let this take care of the rest.
  Dir.glob("#{File.dirname(__FILE__)}/../lib/origen_updater_dev/**/*.rb").sort.each do |file|
    require file
  end
end
