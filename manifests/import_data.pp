define opal::import_data($opal_path = '/usr/bin/opal', $opal_password = 'password', $path="") {

  # include ::opal::update_admin_password

  exec { "import_data_${name}":
    command => "${opal_path} import-xml --opal http://localhost:8080 -u administrator -p '${opal_password}' --path ${path} --destination ${name}",
    unless  => "${opal_path} rest /datasource/${name}/tables --opal http://localhost:8080 --user administrator --password '${opal_password}' --json | grep 'table'",
    require => Class[::opal::install],
  }

}


