require 'fileutils'
# require 'byebug' # Un-comment to debug this file

if Origen.site_config.gem_manage_bundler && Origen.site_config.gem_use_from_system
  Origen.site_config.gem_use_from_system.each do |gem, version|
    begin
      spec = Gem::Specification.find_by_name(gem, version)
      begin
        (spec.executables || []).each do |bin|
          unless File.exist?("#{local_gem_dir}/bin/#{bin}")
            FileUtils.cp("#{spec.bin_dir}/#{bin}", "#{local_gem_dir}/bin")
          end
        end
        p = Pathname.new(spec.cache_file)
        unless File.exist?("#{local_gem_dir}/cache/#{p.basename}")
          FileUtils.cp(spec.cache_file, "#{local_gem_dir}/cache")
        end
        if spec.extension_dir && File.exist?(spec.extension_dir)
          spec.extension_dir =~ /.*extensions(.*)/
          sub_dir = Pathname.new(Regexp.last_match(1)).dirname.to_s
          local_ext_dir = "#{local_gem_dir}/extensions/#{sub_dir}"
          FileUtils.mkdir_p(local_ext_dir) unless File.exist?(local_ext_dir)

          # If the file exists in the extensions directory, skip copying it over.
          p = Pathname.new(spec.extension_dir)
          unless File.exist?("#{local_ext_dir}/#{p.basename}")
            FileUtils.cp_r(spec.extension_dir, local_ext_dir)
          end
        end

        # If the file exists in the gem directory, skip copying it over.
        p = Pathname.new(spec.gem_dir)
        unless File.exist?("#{local_gem_dir}/gems/#{p.basename}")
          FileUtils.cp_r(spec.gem_dir, "#{local_gem_dir}/gems")
        end
        # If the file exists in the specifications directory, skip copying it over.
        p = Pathname.new(spec.spec_file)
        unless File.exist?("#{local_gem_dir}/specifications/#{p.basename}")
          FileUtils.cp(spec.spec_file, "#{local_gem_dir}/specifications")
        end
      rescue
        puts "Had problems installing #{spec.name} from your system Ruby, proceeding with fingers crossed..."
      end

    rescue Gem::LoadError
      # This just means that one of the gems that should be copied from the system
      # was not actually installed in the system, so nothing we can do about that here
    end
  end
end

if ENV['BUNDLE_BIN']
  FileUtils.rm_rf(ENV['BUNDLE_BIN'])

  if ARGV.first == 'all'
    system 'bundle update'
  elsif ARGV.empty?
    system 'bundle'
  else
    system "bundle update #{ARGV.join(' ')}"
  end
end
