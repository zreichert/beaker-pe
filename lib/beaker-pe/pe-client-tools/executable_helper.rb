module PEClientTools
  module ExecutableHelper

    def puppet_access_on(*args, &block)
      Private.tool(:access, *args, &block)
    end
    private

    def puppet_code_on(*args, &block)
      Private.tool(:code, *args, &block)
    end

    def puppet_job_on(*args, &block)
      Private.tool(:job, *args, &block)
    end

    def puppet_app_on(*args, &block)
      Private.tool(:app, *args, &block)
    end


    class Private

      include Beaker::DSL

      def self.tool(tool, *args, &block)

        host = args.shift
        options = {:cmdexe => true}
        options.merge!(args.pop) if args.last.is_a?(Hash)

        if host.platform =~ /win/i

          program_files = host.exec(Command.new('echo', ['%PROGRAMFILES%'], :cmdexe => true)).stdout.chomp.gsub('\\', '\\\\\\')
          client_tools_dir = "#{program_files}\\\\#{['Puppet_Labs', 'Client', 'tools', 'bin'].join('\\\\')}\\\\"
          tool_executable = '""' << "#{client_tools_dir}puppet-#{tool.to_s}.exe" << '""'

          #TODO does this need to be more detailed to pass exit codes????
          batch_contents =<<-EOS
    #{tool_executable} #{args.join}
          EOS

          @command = build_win_batch_command(host, batch_contents, options)
        else

          base_tool_path = '/etc/puppetlabs/client/tools'
          path_seperator = '/'
          tool_executable = '""' << base_tool_path << path_seperator << "puppet-#{tool.to_s}" << '""'
          @command = Command.new(tool_executable, args, options)
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

      def self.build_win_batch_command(host, batch_contents, command_options)
        timestamp = Time.new.strftime('%Y-%m-%d_%H.%M.%S')
        create_remote_file(host, timestamp, batch_contents)
        Command.new(timestamp, [], command_options)
      end
    end
  end
end
