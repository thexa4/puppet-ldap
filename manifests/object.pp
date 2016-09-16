define ldap::object (
  $attributes,
  $ensure,
  $authtype = 'SIMPLE',
  $adduser = '',
  $addpw = '',
){
  if ($authtype == 'SIMPLE') {
    file { "/etc/ldap/additions/${title}.pwdfile":
      ensure  => file,
      content => $addpw,
      mode    => '0660',
      require => File['/etc/ldap/additions'],
    }
    File["/etc/ldap/additions/${title}.pwdfile"] -> File["/etc/ldap/additions/${title}.add"]

    $addition = "-xy '/etc/ldap/additions/${title}.pwdfile' -D '${adduser}'"
  } elsif ($authtype == 'EXTERNAL') {
    $addition = '-Y EXTERNAL'
  } else {
    notice{ "Auth type ${authtype} not recognised for ${title}, trying with -Y ${authtype}": }
    $addition = "-Y ${authtype}"
  }

  if !defined(Package['ldap-utils']) {
    package{ 'ldap-utils':
      ensure => installed,
    }
  }

  if $ensure == 'present' {
    exec { "ldapadd ${title}":
      environment => 'HOME=/root',
      command     => "/usr/bin/ldapadd ${addition} -f '/etc/ldap/additions/${title}.add'",
      unless      => "/usr/bin/ldapsearch ${addition} -b '${title}' -s base",
      require     => [ File["/etc/ldap/additions/${title}.add"], Package['ldap-utils'] ],
    }

    exec { "ldapmodify ${title}":
      environment => 'HOME=/root',
      command     => "/usr/bin/ldapmodify ${addition} -f '/etc/ldap/additions/${title}.modify'",
      onlyif      => "/usr/bin/ldapsearch ${addition} -b '${title}' -s base",
      require     => [ File["/etc/ldap/additions/${title}.modify"], Package['ldap-utils'] ],
    }

    if ! defined(File['/etc/ldap/additions']) {
      file { '/etc/ldap/additions':
        ensure => directory,
        mode   => '0770',
      }
    }

    file { "/etc/ldap/additions/${title}.add":
      ensure  => file,
      content => template('ldap/ldapadd.erb'),
      mode    => '0660',
      require => File['/etc/ldap/additions'],
    }
    
    file { "/etc/ldap/additions/${title}.modify":
      ensure  => file,
      content => template('ldap/ldapmodify.erb'),
      mode    => '0660',
      require => File['/etc/ldap/additions'],
    }
    

  } elsif $ensure == 'absent' {
    notice{ "Ensure absent not yet implemented for ${title}": }
  }
}
