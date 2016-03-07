# Class: opal::repository
# ===========================
#
# Installs the yum and apt-get source repo for Opal
#
# Parameters
# ----------
#
# * `release`
# Relase branch of the opal to be installed from the package repo. Default is 'stable'
#
# Examples
# --------
#
# @example
#    class { 'opal::repository':
#    }
#
# Authors
# -------
#
# Neil Parley
#

class opal::repository ($release = 'stable') {

  case $::operatingsystem {
    'Ubuntu': {
      include ::apt
      apt::source { 'obiba':
        location    => 'http://pkg.obiba.org',
        release     => "$release/",
        repos       => '',
        key         => { 'source' => 'http://pkg.obiba.org/obiba.org.key', 'id' =>  'B5719EDAB71FF8E6F6D008D95991857D7A49E499' },
        include     => { 'src' => false },
        notify      => Class['apt::update'],
      }
    }
    'Centos': {
      yumrepo { 'obiba-stable':
        ensure     => 'present',
        descr      => 'OBiBa Package Repository',
        enabled    => '1',
        gpgcheck   => '1',
        gpgkey     => 'http://pkg.obiba.org/obiba.org.key',
        baseurl    => "http://rpm.obiba.org/$release/",
      }
    }
  }
}