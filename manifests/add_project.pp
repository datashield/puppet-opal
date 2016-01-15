define opal::add_project($opal_path = '/usr/bin/opal', $opal_pass = 'password', $payload="") {

  # include ::opal::update_admin_password

  exec { "register_db_${name}":
    command => "/usr/bin/env echo \"${payload}\" | ${opal_path} rest -o http://localhost:8080 -u administrator -p ${opal_pass} -m  POST /projects --content-type \"application/json\"",
    unless  => "${opal_path} rest /projects --opal http://localhost:8080 --user administrator --password ${opal_pass} --json | grep \"\\\"name\\\": \\\"${name}\\\"\"",
    require => [Service['opal'], Service['rserver']],
  } -> Class['::opal::update_admin_password']

}


