class opal::install($opal_password='password', $opal_password_hash = '$shiro1$SHA-256$500000$dxucP0IgyO99rdL0Ltj1Qg==$qssS60kTC7TqE61/JFrX/OEk0jsZbYXjiGhR7/t+XNY=')  {

  include wait_for

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

  class {opal::update_admin_password: opal_password_hash => $opal_password_hash} ->
  wait_for { 'curl -s -o /dev/null localhost:8080':
    exit_code         => 0,
    polling_frequency => 10.0,
    max_retries       => 5,
  } ->
  exec { 'opal_login' :
    command => "opal system --opal http://localhost:8080 --user administrator --password '${opal_password}' --conf",
    path => "/usr/bin:/bin",
  }

}