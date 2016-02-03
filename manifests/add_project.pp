define opal::add_project($opal_path = '/usr/bin/opal', $opal_password = 'password', $database="mongodb", $description) {

  $payload = "{\\\"name\\\": \\\"${name}\\\", \\\"title\\\": \\\"${name}\\\", \\\"description\\\": \\\"$description\\\", \\\"database\\\": \\\"$database\\\" }"

  exec { "register_db_${name}":
    command => "/usr/bin/env echo \"${payload}\" | ${opal_path} rest -o http://localhost:8080 -u administrator -p '${opal_password}' -m  POST /projects --content-type \"application/json\"",
    unless  => "${opal_path} rest /projects --opal http://localhost:8080 --user administrator --password '${opal_password}' --json | grep \"\\\"name\\\": \\\"${name}\\\"\"",
    require => Class[::opal::install],
  }

}


