# Type: opal::database
# ===========================
#
# Register a database with Opal. $name will be the database name in Opal.
#
# Parameters
# ----------
#
# * `opal_path`
# Path to the opal binary. Default: '/usr/bin/opal'
#
# * `opal_password`
# Opal admin password. Default is 'password'
#
# * `opal_url`
# URL of the Opal REST server. Default is 'http://localhost:8080'
#
# * `db_type`
# Type of database, can be 'mysql' or 'mongodb'. Default is 'mysql'.
#
# * `usedForIdentifiers`
# If the database is going to be used as an identifier database. Default is false
#
# * `usage`
# The usage of the database. Default is 'STORAGE'
#
# * `defaultStorage`
# If the database will be used as the default storage. Default is false
#
# * `url`
# The database connection URL for example: 'mongodb://localhost:27017/opal_data'
#
# * `username`
# The database username
#
# * `password`
# The database password
#
# Examples
# --------
#
# @example
# ::opal::database { 'mongodb':
#   opal_password      => $opal_password,
#   db_type            => 'mongodb',
#   usedForIdentifiers => false,
#   defaultStorage     => true,
#   url                => 'mongodb://localhost:27017/opal_data'
# }
#
# Authors
# -------
#
# Neil Parley
#

define opal::database($opal_path = '/usr/bin/opal', $opal_password = 'password', $opal_url='http://localhost:8080', $db_type='mysql',
  $usedForIdentifiers=false, $usage='STORAGE', $defaultStorage = false, $url, $username='', $password='') {

  $usedForIdentifiers_str = bool2str($usedForIdentifiers)
  $defaultStorage_str = bool2str($defaultStorage)

  if ($db_type == 'mysql'){
    $payload = "{\\\"usedForIdentifiers\\\": ${usedForIdentifiers_str}, \\\"name\\\": \\\"${name}\\\", \\\"usage\\\": \\\"${usage}\\\",
    \\\"defaultStorage\\\": ${defaultStorage_str}, \\\"sqlSettings\\\": {
    \\\"url\\\": \\\"${url}\\\", \\\"driverClass\\\": \\\"com.mysql.jdbc.Driver\\\", \\\"username\\\": \\\"${username}\\\",
    \\\"password\\\": \\\"${password}\\\", \\\"properties\\\": \\\"\\\", \\\"sqlSchema\\\": \\\"HIBERNATE\\\" }}"
  } elsif ($db_type == 'mongodb'){
    $payload = "{\\\"usedForIdentifiers\\\": ${usedForIdentifiers_str}, \\\"name\\\": \\\"${name}\\\", \\\"usage\\\": \\\"${usage}\\\",
    \\\"defaultStorage\\\": ${defaultStorage_str}, \\\"mongoDbSettings\\\": {\\\"url\\\": \\\"${url}\\\",
    \\\"username\\\": \\\"${username}\\\", \\\"password\\\": \\\"${password}\\\", \\\"properties\\\": \\\"\\\"}}"
  } else {
    fail("Database type not available")
  }

  exec { "register_db_${name}":
    command => "/usr/bin/env echo \"${payload}\" | ${opal_path} rest -o ${$opal_url} -u administrator -p '${opal_password}' -m  POST /system/databases --content-type \"application/json\"",
    unless  => ["${opal_path} rest /system/databases --opal ${$opal_url} --user administrator --password '${opal_password}' --json | grep \"\\\"name\\\": \\\"${name}\\\"\"",
      "${opal_path} rest /system/databases/identifiers --opal ${$opal_url} --user administrator --password '${opal_password}' --json | grep \"\\\"name\\\": \\\"${name}\\\"\""],
    require => Class[::opal::install],
  }

}


