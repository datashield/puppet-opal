define opal::datashield_install($r_path = '/usr/bin/R', $opal_pass = 'password') {

  include ::r

  exec { "install_datashield_package_${name}":
    command => "${r_path} -e \"library(opaladmin); o<-opal.login('administrator', '${opal_pass}', url='http://localhost:8080'); dsadmin.install_package(o, '${name}'); dsadmin.set_package_methods(o, pkg='${name}')\" | grep 'TRUE' ",
    unless  => "${r_path} -e \"library(opaladmin); o<-opal.login('administrator', '${opal_pass}', url='http://localhost:8080'); dsadmin.installed_package(o, '${name}')\" | grep 'TRUE' ",
    require => [Class['::r'], Service['opal'], Service['rserver']]
  } -> Class['::opal::update_admin_password']

}