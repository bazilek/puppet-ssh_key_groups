# usage example
# code example that you can use for user creation in your class

define create_user($uid=undef, $userhome=undef, $groups=undef, $key_set=undef) {

  include ssh_key_groups

  $username = $title

  $dotssh = $userhome ? {
    undef     => "/home/$username/.ssh/",
    default   => "${userhome}/.ssh/",
  }

  $ssh_auth_keys_banner = "# managed by puppet\n"
  $ssh_auth_keys = get_public_keys( $key_set )
  $ssh_auth_keys_content = "${ssh_auth_keys_banner}\n${ssh_auth_keys}\n${ssh_auth_keys_banner}"

  user { "$username":
    ensure     => present,
    comment    => "$username user",
    groups     => $groups,
    uid        => $uid,
    home       => $userhome,
    managehome => true,
    shell      => "/bin/bash",
  }

  file { "$username.dotssh" :
    ensure  => directory,
    owner   => $username,
    group   => $username,
    mode    => 700,
    path    => $dotssh,
    require => User["$username"],
  }

  file { "$username.ssh.authkeys":
    owner   => $username,
    group   => $username,
    mode    => 600,
    path    => "$dotssh/authorized_keys",
    content => $ssh_auth_keys_content,
    require => File["$username.dotssh"],
  }
}
