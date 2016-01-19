class opal ($opal_password='password', $opal_password_hash = '$shiro1$SHA-256$500000$dxucP0IgyO99rdL0Ltj1Qg==$qssS60kTC7TqE61/JFrX/OEk0jsZbYXjiGhR7/t+XNY=') {

  class {opal::install: opal_password => $opal_password, opal_password_hash => $opal_password_hash}

}