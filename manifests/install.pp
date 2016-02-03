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

  class {opal::update_admin_password: opal_password_hash => $opal_password_hash} ->
  wait_for { 'curl --fail -s -o /dev/null localhost:8080':
    exit_code         => 0,
    polling_frequency => 15.0,
    max_retries       => 20,
  } ->
  exec { 'opal_login' :
    command => "opal system --opal http://localhost:8080 --user administrator --password '${opal_password}' --conf",
    path => "/usr/bin:/bin",
  }

}