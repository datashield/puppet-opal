class opal::update_admin_password($opal_password_hash = '$shiro1$SHA-256$500000$dxucP0IgyO99rdL0Ltj1Qg==$qssS60kTC7TqE61/JFrX/OEk0jsZbYXjiGhR7/t+XNY=')  {

  $opal_admin_password_hash = $opal_password_hash

  file { '/var/lib/opal/conf/shiro.ini':
    content => template('opal/shiro.erb'),
    ensure  => file,
    owner   => opal,
    group   => adm,
    mode    => '640',
    require => Package['opal'],
    notify  => [Service['opal'], Service['rserver']]
  }

  # if($change_password){
  #   case $::operatingsystem {
  #     'Ubuntu': {
  #       $opal_admin_password_hash = '$shiro1$SHA-256$500000$gcnVxdEmOjaN+NfsK/1NsA==$UOobbhJsBBojnbsfzIBX9GTWjWQFi8aJZxFvFKmOiSE='
  #     }
  #     'Centos': {
  #       $opal_admin_password_hash = '$shiro1$SHA-256$500000$5Zx3jiOtGFLYYqboKSgFgQ==$qUiuEUIMsEfVash4nqtr8A94/GD6B8Kdlv8bll3wg2M='
  #     }
  #   }
  #
  #   file { '/var/lib/opal/conf/shiro.ini':
  #     content => template('opal/shiro.erb'),
  #     ensure  => file,
  #     owner   => opal,
  #     group   => adm,
  #     mode    => '640',
  #     require => Package['opal'],
  #     notify  => Service['opal']
  #   }
  # }
}