define ldap::object (
  $attributes,
  $ensure,
  $adduser,
  $addpw,
){
  if $ensure == 'present' {
    exec { 'ldapadd $title':
      command => '/usr/bin/ldapadd -xy '/etc/ldap/additions/$title.pwdfile' -D '$adduser' -f '/etc/ldap/additions/$title'',
      unless  => '/usr/bin/ldapsearch -xy '/etc/ldap/additions/$title.pwdfile' -D '$adduser' -b '$title' -s base',
      require => [ File['/etc/ldap/additions/$title'], File['/etc/ldap/additions/$title.pwdfile']],
    }

    if ! defined(File['/etc/ldap/additions']) {
      file { '/etc/ldap/additions':
        ensure => directory,
        mode   => '0770',
      }
    }

    file { '/etc/ldap/additions/$title':
      ensure  => file,
      content => template('ldap/ldapadd.erb'),
      mode    => '0660',
      require => File['/etc/ldap/additions'],
    }
    
    file { '/etc/ldap/additions/$title.pwdfile':
      ensure  => file,
      content => $addpw,
      mode    => '0660',
      require => File['/etc/ldap/additions'],
    }

  } elsif $ensure == 'absent' {
    notice { "$title => absent not implemented yet": }
  } 
}
