module PEClientTools
  module ConfigFileHelper

    def write_config_on(host, config_level, tool, contents)

      # TODO take a hash and parse file or take literal string

      file = "#{PrivateMethods.config_path(host, config_level)}#{PrivateMethods.file_name(tool)}"
      create_remote_file(host, file, contents)
    end


    class PrivateMethods

      include Beaker::DSL

      def file_name(tool)
        if tool =~ /orchestrator/i
          'orchestrator.conf'
        elsif tool =~ /puppet.code/i
          'puppet-code.conf'
        elsif tool =~ /puppet.access/i
          'puppet-access.conf'
        else
          raise ArguementError.new("Unknown pe-client-tool type '#{tool}'")
        end
      end

      def config_path(host, config_level)

        puppetlabs_dir = 'puppetlabs'
        puppetlabs_dir.prepend('.') if config_level == 'user'
        client_tools_path_array = [puppetlabs_dir, 'client-tools']

        case config_level

          when /global/
            @base_path = global_base_path(host)
          when /user/
            @base_path = home_dir(host)
          else
            raise ArguementError.new("Unknown config level #{config_level}")
        end

        client_tools_dir = client_tools_path_array.unshift(base_path).join(path_separator(host))
        if host.platform =~ /win/
          on(client, Command.new('MD', [client_tools_dir.gsub('\\', '\\\\\\')], :cmdexe => true))
        else
          on(client, "mkdir -p #{@client_tools_dir}")
        end
        client_tools_dir
      end

      def self.home_dir(host)

        (host.platform =~ /win/) ? @cmd = Command.new('echo', ['%userprofile%'], :cmdexe => true) : @cmd = 'echo $HOME'
        on(host, @command).stdout.chomp
      end

      def self.global_base_path(host)

        #TODO need win base path
        (host.platform =~ /win/) ? '' : '/etc//'
      end

      def self.path_separator(host)

        (host.platform =~ /win/) ? '\\' : '/'
      end
    end
  end
end