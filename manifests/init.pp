class ldap(
    $base,
    $uri,
    $ssl = false,
    $cert_ca = '/etc/ssl/certs/host-ca.crt',
    $cert_client = '/etc/ssl/certs/host.crt',
    $key_client = '/etc/ssl/private/host.key',
  ) {
  
  if ($ssl) {
    class { 'openldap::client':
      base       => $base,
      uri        => $uri,
      tls_cacert => $cert_ca,
    }

    file { '/root/.ldaprc':
      ensure  => file,
      content => "# Managed by puppet\nTLS_CERT ${cert_client}\nTLS_KEY ${key_client}",
    }
  } else {
    class { 'openldap::client':
      base => $base,
      uri  => $uri,
    }
  }
}
