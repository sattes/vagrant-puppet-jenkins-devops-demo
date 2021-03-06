#install fpm for RPM builds
exec { "install-fpm":
  path    => "/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin",
  command => "gem install fpm --no-rdoc --no-ri",
  unless  => "test -f /usr/bin/fpm",
}

#install java, needed for jenkins slave
exec { "install-java":
  path    => "/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin",
  command => "yum install java-1.7.0-openjdk -y",
  unless  => "test -f /usr/bin/java",
}

exec { "install-createrepo":
  path    => "/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin",
  command => "yum install createrepo -y",
  unless  => "test -f /usr/bin/createrepo",
}
