#Ldap
Sets up ldap using camptocamp-openldap and allows other modules to ensure certain ldap entries

##Parameters
* `$base` - The base dn
* `$uri` - The uri to the ldap server
* `$ssl = false` - Should SSL be enabled?
* `$cert_ca = '/etc/ssl/certs/host-ca.crt'` - The ca certificate to validate the server with
* `$cert_client = '/etc/ssl/certs/host.crt'` - The client certificate configured for root
* `$key_client = '/etc/ssl/private/host.key'` - The key configured for root

##Types

###`ldap::object`
This object tries to ensure the state of an entry in ldap.

####Parameters
* `$title` - The dn of the entry
* `$attributes` - A hash of attributes the entry should contain
* `$ensure` - present, absent
* `$authtype = 'SIMPLE'` - The authentication method, use SIMPLE for password authentication, EXTERNAL for ssl authentication
* `$adduser = ''` - When used with SIMPLE, the user to authenticate with
* `$addpw = ''` - When used with SIMPLE, the password to authenticate with

####Example
    ldap::object { "cn=puppet,dc=example,dc=com":
      ensure          => present,
      authtype        => 'EXTERNAL',
      attributes      => {
        'cn'          => 'puppet',
        'objectClass' => [
          'device',
          'ipHost',
          'ieee802Device',
          'puppetClient',
        ],
        'ipHostNumber' => '127.0.0.1'
        'macAddress'   => '00:00:00:00:00:00',
      },
    }
