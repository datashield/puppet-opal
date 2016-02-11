define opal::project($opal_path = '/usr/bin/opal', $opal_password = 'password', $opal_url='http://localhost:8080', $database="mongodb", $description) {

  $payload = "{\\\"name\\\": \\\"${name}\\\", \\\"title\\\": \\\"${name}\\\", \\\"description\\\": \\\"$description\\\", \\\"database\\\": \\\"$database\\\" }"

  exec { "register_db_${name}":
    command => "/usr/bin/env echo \"${payload}\" | ${opal_path} rest -o ${$opal_url} -u administrator -p '${opal_password}' -m  POST /projects --content-type \"application/json\"",
    unless  => "${opal_path} rest /projects --opal ${$opal_url} --user administrator --password '${opal_password}' --json | grep \"\\\"name\\\": \\\"${name}\\\"\"",
    require => [Class[::opal::install], Opal::Database[$database]]
  }

}


