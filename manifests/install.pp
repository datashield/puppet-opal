class opal::install($opal_password='password', $opal_url='http://localhost:8080',
  $opal_password_hash = '$shiro1$SHA-256$500000$dxucP0IgyO99rdL0Ltj1Qg==$qssS60kTC7TqE61/JFrX/OEk0jsZbYXjiGhR7/t+XNY=')  {

  include wait_for

  class { 'opal::repository': before => [Package['opal'], Package['opal-rserver'], Package['opal-python-client']] }

  case $::operatingsystem {
    'Ubuntu': {
      package { 'opal':
        ensure  => latest,
        require => Class['::r']
      } ~>
      service { 'opal':
        ensure => running,
        enable => true,
      }
    }
    'Centos': {
      package { 'opal-server':
        ensure  => latest,
        require => Class['::r'],
        alias   => 'opal'
      } ~>
      service { 'opal':
        ensure => running,
        enable => true,
      }
    }
  }

  package { 'opal-python-client':
    ensure  => latest,
    require => Package['opal']
  }

  package { 'opal-rserver':
    ensure  => latest,
    require => Package['opal']
  } ~>
  service { 'rserver':
    ensure => running,
    enable => true,
  }

  class { ::opal::admin_password: opal_password_hash => $opal_password_hash } ->
  wait_for { "curl --fail -s -o /dev/null ${$opal_url}":
    exit_code         => 0,
    polling_frequency => 15.0,
    max_retries       => 20,
  } ->
  exec { 'opal_login' :
    command => "opal system --opal ${$opal_url} --user administrator --password '${opal_password}' --conf",
    path    => "/usr/bin:/bin",
  }

}