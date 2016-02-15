# Opal

#### Table of Contents

1. [Description](#description)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Description

This module gives you the ability to install and manage opal. 

## Usage

To install Opal you need to include the class:

```puppet
class { '::opal': }
```

You can also pass a new admin password to opal. By defining the password and the password hash.

```puppet
class { '::opal':
  opal_password      => 'password', 
  opal_password_hash => '$shiro1$SHA-256$500000$dxucP0IgyO99rdL0Ltj1Qg==$qssS60kTC7TqE61/JFrX/OEk0jsZbYXjiGhR7/t+XNY=',
}
```

`opal::database` can be used to register a database with opal, for example:

```puppet
::opal::database { 'mongodb':
  opal_password      => $opal_password,
  db                 => 'mongodb',
  usedForIdentifiers => 'false',
  defaultStorage     => 'true',
  url                => 'mongodb://localhost:27017/opal_data'
}
```

`opal::project` can be used to add a project to opal, for example:
 
```puppet
::opal::project { 'CNSIM':
  opal_password => $opal_password,
  database      => "mongodb",
  description   => "Simulated data",
}
```
    
Data can be imported into a project using `opal::data`, for example:

```puppet
::opal::data { 'CNSIM':
  opal_password => $opal_password,
  path          => '/home/administrator/testdata/CNSIM/CNSIM.zip',
}
```    

## Reference

### opal::admin_password

```puppet
opal::admin_password($opal_password_hash = '$shiro1$SHA-256$500000$dxucP0IgyO99rdL0Ltj1Qg==$qssS60kTC7TqE61/JFrX/OEk0jsZbYXjiGhR7/t+XNY=') 
```
This submodule changes the opal admin password. Supply the function with the password hash of the password that
you would like to change to. `$opal_password_hash` is the password hash (see Opal documentations for how to create
a password hash). The default password hash is the default hash for Opal on install. 
 
### opal::data

```puppet
define opal::data($opal_path = '/usr/bin/opal', $opal_password = 'password', $opal_url='http://localhost:8080', $path="")
```
Data type to import data into opal. Name must match an `opal::project` name. `$opal_path` is the path to the
opal bin. `$opal_password` is the opal admin password. `$path` is the path to the zip file containing the opal
data. `$opal_url` is the url of the opal REST server.

### opal::database

```puppet
define opal::database($opal_path = '/usr/bin/opal', $opal_password = 'password', $opal_url='http://localhost:8080', $db='mysql',
  $usedForIdentifiers='false', $usage='STORAGE', $defaultStorage = 'false', $url, $username='', $password='')
```
Type to register a database with Opal. `$opal_path` is the path to the opal bin. `$opal_password` is the opal admin 
password. `$db_type` is the type of database and can be 'mysql' or 'mongodb'. `$usedForIdentifiers` definds if
the database is an identifier database. `$usage` is the usage of the database, default 'STORAGE'. `$defaultStorage` is
defines if this is the default database storage. `$url` defines the url of the database server, for example
'mongodb://localhost:27017/opal_ids'. `$username` is the username for the database server, and `$password` is the password
for the database server. `$opal_url` is the url of the opal REST server.

### opal::install

```puppet
class opal::install($opal_password='password', $opal_url='http://localhost:8080',
  $opal_password_hash = '$shiro1$SHA-256$500000$dxucP0IgyO99rdL0Ltj1Qg==$qssS60kTC7TqE61/JFrX/OEk0jsZbYXjiGhR7/t+XNY=')
```
Installs Opal and starts the Opal and rserve service. Changes the admin password to `$opal_password_hash`, default is the
default Opal password. Checks that the Opal web server is run and the REST interface accepts requests. `$opal_url` is the
url of the opal REST server.

### opal::project

```puppet
define opal::project($opal_path = '/usr/bin/opal', $opal_password = 'password', $opal_url='http://localhost:8080', $database="mongodb", $description)
```
Add a project to Opal. `$opal_path` is the path to the opal bin. `$opal_password` is the opal admin password. `$database` 
is the database for the project to use, must be a `opal::database` resource (i.e. `Opal::Database['mongodb']`). `$description` 
is text about the project. `$opal_url` is the url of the opal REST server.

### opal::repository

```puppet
class opal::repository
```
Class to install the Opal yum or apt-get source repos onto the system.

## Limitations

Has only been tested on Ubuntu 14.04 and Centos 7. 

## Development

Open source, forks and pull requests welcomed. 

