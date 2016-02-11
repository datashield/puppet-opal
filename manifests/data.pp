define opal::data($opal_path = '/usr/bin/opal', $opal_password = 'password', $opal_url='http://localhost:8080', $path="") {

  # include ::opal::update_admin_password

  exec { "import_data_${name}":
    command => "${opal_path} import-xml --opal ${$opal_url} -u administrator -p '${opal_password}' --path ${path} --destination ${name}",
    unless  => "${opal_path} rest /datasource/${name}/tables --opal ${$opal_url} --user administrator --password '${opal_password}' --json | grep 'table'",
    require => [Class[::opal::install], Opal::Project[$name]]
  }

}


