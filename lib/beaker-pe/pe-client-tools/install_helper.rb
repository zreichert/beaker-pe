module Beaker
  module DSL
    module InstallUtils
      module PEClientTools

        def install_pe_client_tools_on(hosts, opts = {})
          # FIXME: accomodate production released location(s)
          #{{{
          product = 'pe-client-tools'
          required_keys = [:puppet_collection, :pe_client_tools_sha, :pe_client_tools_version]

          unless required_keys.all? { |opt| opts.keys.include?(opt) }
            raise ArgumentError, "The keys #{required_keys.to_s} are required in the opts hash"
          end
          urls = { :dev_builds_url   => "http://builds.delivery.puppetlabs.net",
          }

          opts = urls.merge(opts)

          block_on hosts do |host|
            package_name = nil
            variant, version, arch, codename = host['platform'].to_array
            case host['platform']
            when /el-|fedora|sles|centos|cisco_/
              release_path = "#{opts[:dev_builds_url]}/#{product}/#{ opts[:pe_client_tools_sha] }/artifacts/#{variant}/#{version}/#{opts[:puppet_collection]}/#{arch}"
              package_name = product.dup
              package_name << "-#{opts[:pe_client_tools_version]}-1.#{variant}#{version}.#{arch}.rpm" if opts[:pe_client_tools_version]
            when /debian|ubuntu|cumulus|huaweios/
              release_path = "#{opts[:dev_builds_url]}/#{product}/#{ opts[:pe_client_tools_sha] }/artifacts/deb/#{codename}/#{opts[:puppet_collection]}"
              package_name = product.dup
              package_name << "_#{opts[:pe_client_tools_version]}-1#{host['platform'].codename}_#{arch}.deb" if opts[:pe_client_tools_version]
            when /windows/
              release_path = "#{opts[:dev_builds_url]}/#{product}/#{ opts[:pe_client_tools_sha] }/artifacts/#{variant}/#{opts[:puppet_collection]}/x#{arch}"
              package_name = product.dup
              package_name << "-#{opts[:pe_client_tools_version]}.1-x#{arch}_VANAGON.msi" if opts[:pe_client_tools_version]
            when /osx/
              release_path = "#{opts[:dev_builds_url]}/#{product}/#{ opts[:pe_client_tools_sha] }/artifacts/apple/#{version}/#{opts[:puppet_collection]}/#{arch}"
              package_base = product.dup
              package_base << "-#{opts[:pe_client_tools_version]}" if opts[:pe_client_tools_version]
              package_name = package_base.dup
              package_name << '-1' if opts[:pe_client_tools_version]
              installer    = package_name + '-installer.pkg'
              package_name << ".#{variant}#{version}.dmg" if opts[:pe_client_tools_version]
            else
              raise "install_puppet_agent_on() called for unsupported " +
                "platform '#{host['platform']}' on '#{host.name}'"
            end

            if package_name
              case host['platform']
              when /windows/
                install_msi_on(host, File.join(release_path, package_name), {}, opts)
              else
                copy_dir_local = File.join('tmp', 'repo_configs')
                fetch_http_file(release_path, package_name, copy_dir_local)
                scp_to host, File.join(copy_dir_local, package_name), host.external_copy_base

                if host['platform'] =~ /debian|ubuntu|cumulus|huaweios/
                  on host, "dpkg -i #{package_name}"
                elsif host['platform'] =~ /osx/
                  install_dmg_on(host, package_name, package_base, installer, opts)
                else
                  host.install_package( package_name )
                end
              end
            end
          end
          #}}}
        end

        def install_dmg_on(host, dmg_path, pkg_base, pkg_name, opts = {})
          dmg_name = File.basename(dmg_path, '.dmg')
          on(host, "hdiutil attach #{dmg_name}.dmg")
          on(host, "installer -pkg /Volumes/#{pkg_base}/#{pkg_name} -target /")
        end

        def install_msi_on(hosts, msi_path, msi_opts = {}, opts = {})
          #{{{
          block_on hosts do | host |
            msi_opts['PUPPET_AGENT_STARTUP_MODE'] ||= 'Manual'
            batch_path, log_file = create_install_msi_batch_on(host, msi_path, msi_opts)

            # begin / rescue here so that we can reuse existing error msg propagation
            begin
              # 1641 = ERROR_SUCCESS_REBOOT_INITIATED
              # 3010 = ERROR_SUCCESS_REBOOT_REQUIRED
              on host, Command.new("\"#{batch_path}\"", [], { :cmdexe => true }), :acceptable_exit_codes => [0, 1641, 3010]
            rescue
              on host, Command.new("type \"#{log_file}\"", [], { :cmdexe => true })
              raise
            end

            if opts[:debug]
              on host, Command.new("type \"#{log_file}\"", [], { :cmdexe => true })
            end

            if !host.is_cygwin?
              # HACK: for some reason, post install we need to refresh the connection to make puppet available for execution
              host.close
            end

          end
          #}}}
        end

      end
    end
  end
end
