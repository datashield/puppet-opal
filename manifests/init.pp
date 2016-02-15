# Class: opal
# ===========================
#
# Install Opal database and start the needed services
#
# Parameters
# ----------
#
# * `opal_password`
# The admin password for managing opal
#
# * `opal_password_hash`
# The opal admin password hash to set the opal admin password
#
# Examples
# --------
#
# @example
#    class { 'opal':
#      opal_password      => 'password',
#      opal_password_hash => '$shiro1$SHA-256$500000$dxucP0IgyO99rdL0Ltj1Qg==$qssS60kTC7TqE61/JFrX/OEk0jsZbYXjiGhR7/t+XNY=',
#    }
#
# Authors
# -------
#
# Neil Parley
#

class opal ($opal_password='password', $opal_password_hash = '$shiro1$SHA-256$500000$dxucP0IgyO99rdL0Ltj1Qg==$qssS60kTC7TqE61/JFrX/OEk0jsZbYXjiGhR7/t+XNY=') {

  include stdlib
  class { opal::install:
    opal_password      => $opal_password,
    opal_password_hash => $opal_password_hash
  }

}