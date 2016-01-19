define opal::db_register($opal_path = '/usr/bin/opal', $opal_password = 'password', $payload="") {

  # include ::opal::update_admin_password

  exec { "register_db_${name}":
    command => "/usr/bin/env echo \"${payload}\" | ${opal_path} rest -o http://localhost:8080 -u administrator -p '${opal_password}' -m  POST /system/databases --content-type \"application/json\"",
    unless  => ["${opal_path} rest /system/databases --opal http://localhost:8080 --user administrator --password '${opal_password}' --json | grep \"\\\"name\\\": \\\"${name}\\\"\"",
    "${opal_path} rest /system/databases/identifiers --opal http://localhost:8080 --user administrator --password '${opal_password}' --json | grep \"\\\"name\\\": \\\"${name}\\\"\""],
    require => Class[::opal::install],
  }

}


