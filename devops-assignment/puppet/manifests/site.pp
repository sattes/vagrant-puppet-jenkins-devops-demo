# Enable remi for mysql avoiding gpgcheck for sake of simplicity
yumrepo { 'remi':
  descr          => "Remi for Enterprise Linux",
  mirrorlist     => "http://rpms.famillecollet.com/enterprise/6.4/remi/mirror",
  failovermethod => 'priority',
  enabled        => '1',
  gpgcheck       => '0',
}

# local yum rpeo to install tomcat, no gpgcheck
yumrepo { 'xebia':
  descr          => "Tomcat as RPM for Enterprise Linux",
  # no mirrors!
  baseurl        => "file:///yum",
  failovermethod => 'priority',
  enabled        => '1',
  gpgcheck       => '0',
}

exec { "install-java":
  path    => "/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin",
  command => "yum install java-1.7.0-openjdk -y",
  unless  => "test -f /usr/bin/java",
  before  => Service["tomcat"],
}

exec { "install-tomcat":
  path    => "/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin",
  command => "yum --enablerepo=xebia install apache-tomcat -y",
  unless  => "test -f /etc/rc.d/init.d/tomcat",
  require => [Yumrepo["xebia"], Exec["install-java"],],
  before  => Service["tomcat"],
}

group { "tomcat":
  ensure   => present,
  system   => true,
  provider => groupadd,
  gid      => 486,
  require  => Exec["install-tomcat"],
  before   => Service["tomcat"],
}

user { "tomcat":
  ensure   => present,
  system   => true,
  provider => useradd,
  uid      => 487,
  gid      => 'tomcat',
  home     => "/apps/tomcat",
  shell    => '/bin/bash',
  require  => Group["tomcat"],
  before   => Service["tomcat"],
}

file { "/apps/tomcat":
  ensure  => directory,
  owner   => 'tomcat',
  group   => 'tomcat',
  require => User["tomcat"],
  before  => Service["tomcat"],
}
 
 exec{ "fix-ownership":
  path    => "/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin",
  command => "sudo chown -R tomcat:tomcat /apps/tomcat",
  unless  => "test -f /etc/init.d/mysql",
  require => [Yumrepo["remi"],User["tomcat"],],
  before => Service["tomcat"],   
 }

service { "tomcat":
  ensure     => running,
  enable     => true,
  hasrestart => true,
  hasstatus  => true,
  require    => [Exec["install-tomcat"],Exec["fix-ownership"],],
}

exec { "install-mysql":
  path    => "/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin",
  command => "yum --enablerepo=remi install mysql mysql-server -y",
  unless  => "test -f /etc/init.d/mysql",
  require => Yumrepo["remi"],
}

service { "mysqld":
  enable  => true,
  ensure  => running,
  require => Exec["install-mysql"],
}

# disbale iptables for this demo
service{ "iptables":
  enable => false,
  ensure => stopped,
}
