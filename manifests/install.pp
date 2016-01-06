class opal::install  {

  class {'opal::repository': before => [Package['opal'], Package['opal-rserver'], Package['opal-python-client']]}

  case $::operatingsystem {
    'Ubuntu': {
      $opal_admin_password_hash = '$shiro1$SHA-256$500000$gcnVxdEmOjaN+NfsK/1NsA==$UOobbhJsBBojnbsfzIBX9GTWjWQFi8aJZxFvFKmOiSE='
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
      $opal_admin_password_hash = '$shiro1$SHA-256$500000$5Zx3jiOtGFLYYqboKSgFgQ==$qUiuEUIMsEfVash4nqtr8A94/GD6B8Kdlv8bll3wg2M='
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

  file { '/var/lib/opal/conf/shiro.ini':
    content => template('opal/shiro.erb'),
    ensure  => file,
    owner   => opal,
    group   => adm,
    mode    => '640',
    require => Package['opal'],
    notify => Service['opal']
  }

}