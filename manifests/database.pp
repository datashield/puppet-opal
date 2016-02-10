define opal::database($opal_path = '/usr/bin/opal', $opal_password = 'password', $db='mysql', $usedForIdentifiers='false', $usage="STORAGE",
                         $defaultStorage = 'false', $url, $username='', $password='') {

  if ($db == 'mysql'){
    $payload = "{\\\"usedForIdentifiers\\\": ${usedForIdentifiers}, \\\"name\\\": \\\"${name}\\\", \\\"usage\\\": \\\"${usage}\\\",
    \\\"defaultStorage\\\": ${defaultStorage}, \\\"sqlSettings\\\": {
    \\\"url\\\": \\\"${url}\\\", \\\"driverClass\\\": \\\"com.mysql.jdbc.Driver\\\", \\\"username\\\": \\\"${username}\\\",
    \\\"password\\\": \\\"${password}\\\", \\\"properties\\\": \\\"\\\", \\\"sqlSchema\\\": \\\"HIBERNATE\\\" }}"
  } elsif ($db == 'mongodb'){
    $payload = "{\\\"usedForIdentifiers\\\": ${usedForIdentifiers}, \\\"name\\\": \\\"${name}\\\", \\\"usage\\\": \\\"${usage}\\\",
    \\\"defaultStorage\\\": ${defaultStorage}, \\\"mongoDbSettings\\\": {\\\"url\\\": \\\"${url}\\\",
    \\\"username\\\": \\\"${username}\\\", \\\"password\\\": \\\"${password}\\\", \\\"properties\\\": \\\"\\\"}}"
  }

  exec { "register_db_${name}":
    command => "/usr/bin/env echo \"${payload}\" | ${opal_path} rest -o http://localhost:8080 -u administrator -p '${opal_password}' -m  POST /system/databases --content-type \"application/json\"",
    unless  => ["${opal_path} rest /system/databases --opal http://localhost:8080 --user administrator --password '${opal_password}' --json | grep \"\\\"name\\\": \\\"${name}\\\"\"",
    "${opal_path} rest /system/databases/identifiers --opal http://localhost:8080 --user administrator --password '${opal_password}' --json | grep \"\\\"name\\\": \\\"${name}\\\"\""],
    require => Class[::opal::install],
  }

}


