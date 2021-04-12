# Class: opal::admin_password
# ===========================
#
# Updates the opal admin password to the password given by $opal_password_hash. To create a password hash for your given
# password please see the Opal documentations.
#
# Parameters
# ----------
#
# * `opal_password_hash`
# Password hash for the Opal admin password as created using the Opal admin password hash instructions.
#
# Examples
# --------
#
# @example
#    class { 'opal::admin_password':
#      opal_password_hash => '$shiro1$SHA-256$500000$dxucP0IgyO99rdL0Ltj1Qg==$qssS60kTC7TqE61/JFrX/OEk0jsZbYXjiGhR7/t+XNY=',
#    }
#
# Authors
# -------
#
# Neil Parley
#

class opal::admin_password($opal_password_hash = '$shiro1$SHA-256$500000$dxucP0IgyO99rdL0Ltj1Qg==$qssS60kTC7TqE61/JFrX/OEk0jsZbYXjiGhR7/t+XNY=')  {

  $opal_admin_password_hash = $opal_password_hash

  file { '/var/lib/opal/conf/shiro.ini':
    content => template('opal/shiro.erb'),
    ensure  => file,
    owner   => opal,
    group   => adm,
    mode    => '640',
    require => Package['opal'],
    notify  => [Service['opal'], Service['rock']]
  }

}
