# Type: opal::project
# ===========================
#
# Add a project to the opal database.
#
# Parameters
# ----------
#
# * `opal_path`
# Path to the opal binary. Default: '/usr/bin/opal'
#
# * `opal_password`
# Opal admin passsword. Default: 'password'
#
# * `opal_url`
# URL of the Opal REST server. Default is 'https://localhost:8443'
#
# * `database`
# Name of the database to use with the project. Must be a Opal::Database[$name] resource.
#
# * `description`
# A description of the project
#
# Examples
# --------
#
# @example
#    ::opal::project { 'CNSIM':
#      opal_password => $opal_password,
#      database      => "mongodb",
#      description   => "Simulated data",
#    }
#
# Authors
# -------
#
# Neil Parley
#

define opal::project($opal_path = '/usr/bin/opal', $opal_password = 'password', $opal_url='https://localhost:8443', $database="mongodb", $description) {

  $payload = "{\\\"name\\\": \\\"${name}\\\", \\\"title\\\": \\\"${name}\\\", \\\"description\\\": \\\"$description\\\", \\\"database\\\": \\\"$database\\\" }"

  exec { "register_db_${name}":
    command => "/usr/bin/env echo \"${payload}\" | ${opal_path} rest -o ${$opal_url} -u administrator -p '${opal_password}' -m  POST /projects --content-type \"application/json\"",
    unless  => "${opal_path} rest /projects --opal ${$opal_url} --user administrator --password '${opal_password}' --json | grep \"\\\"name\\\": \\\"${name}\\\"\"",
    require => [Class[::opal::install], Opal::Database[$database]]
  }

}


