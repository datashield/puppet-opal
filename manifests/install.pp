class opal::install($change_password=false)  {

  class {'opal::repository': before => [Package['opal'], Package['opal-rserver'], Package['opal-python-client']]}

  case $::operatingsystem {
    'Ubuntu': {
      package { 'opal':
        ensure  => 'present',
        require => Class['::r']
      } ~>
      service { 'opal':
        ensure => running,
        enable => true,
      }
    }
    'Centos': {
      package { 'opal-server':
        ensure  => 'present',
        require => Class['::r'],
        alias  => 'opal'
      } ~>
      service { 'opal':
        ensure => running,
        enable => true,
      }
    }
  }

  package {'opal-python-client':
    ensure => 'latest',
    require => Package['opal']
  }

  package {'opal-rserver':
    ensure => 'latest',
    require => Package['opal']
  } ~>
  service { 'rserver':
          ensure => running,
          enable => true,
  }

  # Bug fix for opal and rserver not setting home directory correctly

  case $::operatingsystem {
    'Centos': {
      file {'/home/rserver':
        ensure => link,
        target => "/var/lib/rserver",
        require => Service['rserver']
      }
      file {'/home/opal':
        ensure => link,
        target => "/var/lib/opal",
        require => Service['opal']
      }
    }

  }


  class {opal::update_admin_password: change_password => $change_password}

}