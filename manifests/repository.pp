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
        location       => 'https://obiba.jfrog.io/artifactory/debian-local',
        release        => '',
        repos          => 'all main',
#        key            => { 'server' => 'https://www.obiba.org/assets/obiba-pub.pem', 'id' => '0E52FB02F890D3058B6C964D8576AC157B0A831B' },
#        key            => '0E52FB02F890D3058B6C964D8576AC157B0A831B',
        include        => { 'src' => false },
        notify         => Class['apt::update'],
#        allow_unsigned => false,
        allow_unsigned => true,
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
