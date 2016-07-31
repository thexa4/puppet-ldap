class ldap(
		$base,
		$uri,
		$ssl = false,
	) {
	
	if ($ssl) {
		class { "openldap::client":
			base => $base,
			uri => $uri,
			tls_cacert => "/etc/ssl/certs/host-ca.crt",
		}
	} else {
		class { "openldap::client":
			base => $base,
			uri => $uri,
		}
	}
}
