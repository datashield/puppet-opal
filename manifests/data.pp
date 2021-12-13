# Type: opal::data
# ===========================
#
# Import data from a zip file into an Opal project. $name must exist as a opal::project i.e. Opal::Project[$name] is
# required
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
# * `path`
# Path to the zip file for the imported data
#
# Examples
# --------
#
# @example
# ::opal::data { 'DASIM':
#   opal_password => $opal_password,
#   path          => '/home/administrator/testdata/DASIM/DASIM.zip',
# }
#
# Authors
# -------
#
# Neil Parley
#

define opal::data($opal_path = '/usr/bin/opal', $opal_password = 'password', $opal_url='https://localhost:8443', $path="") {

  exec { "import_data_${name}":
    command => "${opal_path} import-xml --opal ${$opal_url} -u administrator -p '${opal_password}' --path ${path} --destination ${name}",
    unless  => "${opal_path} rest /datasource/${name}/tables --opal ${$opal_url} --user administrator --password '${opal_password}' --json | grep 'table'",
    require => [Class[::opal::install], Opal::Project[$name]]
  }

}


