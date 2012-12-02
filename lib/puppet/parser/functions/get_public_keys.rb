module Puppet::Parser::Functions
  newfunction(:get_public_keys, :type => :rvalue) do |args|
      module_path = Puppet::Module.find("ssh_key_groups", compiler.environment.to_s)
      path_to_keys = lookupvar("ssh_key_groups::config::path_to_keys")
      default_domain = lookupvar("ssh_key_groups::config::default_domain")
      file_suffix = lookupvar("ssh_key_groups::config::file_suffix")
      @not_defined_error = <<END
ssh_key_groups module configuration is incomplete:
- You should define $path_to_keys $default_domain $file_suffix vars in ssh_key_groups::config
- Values may be empty.
- Path to keys is relative to module dir
END
      if ( path_to_keys == :undefined || default_domain == :undefined || file_suffix == :undefined ) then
          raise Puppet::ParseError, @not_defined_error
      end
      ssh_keys_files_path = module_path.path + '/' + path_to_keys + '/'
      keys = ''
      args[0].each do |user|
          Puppet::Parser::Functions.function('get_public_keys')
          user_to_lookup = "ssh_key_groups::groups::"+user
          users = lookupvar(user_to_lookup)
          if ( users != nil && users != :undefined && users.length > 0)  then
              keys << function_get_public_keys( [ users ] )
          else
              if ( user =~ /@/ ) then
                  # full key name provided
                  file = ssh_keys_files_path+user+file_suffix
              else
                  # short name provided - using default domain
                  file = ssh_keys_files_path+user+default_domain+file_suffix
              end
              keys << IO.read(file)
          end
      end
      keys
  end
end
