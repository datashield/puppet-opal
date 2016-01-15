define opal::import_data($opal_path = '/usr/bin/opal', $opal_pass = 'password', $path="") {

  # include ::opal::update_admin_password

  exec { "import_data_${name}":
    command => "${opal_path} import-xml --opal http://localhost:8080 -u administrator -p ${opal_pass} --path ${path} --destination ${name}",
    unless  => "${opal_path} rest /datasource/${name}/tables --opal http://localhost:8080 --user administrator --password ${opal_pass} --json | grep 'table'",
    require => [Service['opal'], Service['rserver']],
  } -> Class['::opal::update_admin_password']

}


