module Beaker
  module DSL
    module PEClientTools
      module ExecutableHelper

        def puppet_access_on(*args, &block)
          Private.new.tool(:access, *args, &block)
        end

        def puppet_code_on(*args, &block)
          Private.new.tool(:code, *args, &block)
        end

        def puppet_job_on(*args, &block)
          Private.new.tool(:job, *args, &block)
        end

        def puppet_app_on(*args, &block)
          Private.new.tool(:app, *args, &block)
        end


        class Private

          include Beaker::DSL
          include Beaker::DSL::Wrappers
          include Beaker::DSL::Helpers::HostHelpers
          include Beaker::DSL::Patterns

          attr_accessor :logger

          def tool(tool, *args, &block)

            host = args.shift
            @logger = host.logger
            options = {:cmdexe => true}
            options.merge!(args.pop) if args.last.is_a?(Hash)

            if host.platform =~ /win/i

              program_files = host.exec(Beaker::Command.new('echo', ['%PROGRAMFILES%'], :cmdexe => true)).stdout.chomp
              client_tools_dir = "#{program_files}\\#{['Puppet Labs', 'Client', 'tools', 'bin'].join('\\')}\\"
              tool_executable = "\"#{client_tools_dir}puppet-#{tool.to_s}.exe\""

              #TODO does this need to be more detailed to pass exit codes????
              # TODO make batch file direct output to separate file
              batch_contents =<<-EOS
call #{tool_executable} #{args.join}
              EOS

              @command = build_win_batch_command( host, batch_contents, options)
            else

              tool_executable = '/opt/puppetlabs/client-tools/bin/' << "puppet-#{tool.to_s}"
              @command = Beaker::Command.new(tool_executable, args, options)
            end

            result = host.exec(@command)

            # Also, let additional checking be performed by the caller.
            if block_given?
              case block.arity
                #block with arity of 0, just hand back yourself
                when 0
                  yield self
                #block with arity of 1 or greater, hand back the result object
                else
                  yield result
              end
            end
            result
          end

          def build_win_batch_command( host, batch_contents, command_options)
            timestamp = Time.new.strftime('%Y-%m-%d_%H.%M.%S')
            # Create Temp file
            # make file fully qualified
            batch_file = "#{host.system_temp_path}\\#{timestamp}.bat"
            create_remote_file(host, batch_file, batch_contents)
            Beaker::Command.new("\"#{batch_file}\"", [], command_options)
          end
        end
      end
    end
  end
end

