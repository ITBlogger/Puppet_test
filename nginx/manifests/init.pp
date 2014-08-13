class nginx (
  $http_port = '8000',
) {

# Firewall is off on vagrant system, but in production it would be on, so need to set firewall rule to allow https
  include nginx::fw

# Need epel installed before nginx will install
  file {'epel 6.8':
    ensure => file,
    path   => '/tmp/epel-release-6-8.noarch.rpm',
    source => 'puppet:///modules/nginx/epel-release-6-8.noarch.rpm',
  } ->
# install epel using exec because Puppet returns an error if package is already installed when installing from a file
  exec {'epel 6.8':
    command => '/usr/bin/yum install /tmp/epel-release-6-8.noarch.rpm',
    unless  => '/usr/bin/yum list installed | /bin/grep "epel-release"',
  } ->
  package {'nginx':
    ensure => present,
  } ->
  file {'puppet_test':
    ensure => file,
    path   => '/var/www/html/puppet_test.html',
    source => 'puppet:///modules/nginx/puppet_test.html',
    owner  => 'nginx',
    mode   => '0755',
  } ->
  file {'puptest.conf':
    ensure  => file,
    path    => '/etc/nginx/conf.d/puptest.conf',
    content => template('nginx/puptest.conf.erb'),
    owner   => 'root',
    mode    => '0755',
  } ~>
  service {'nginx':
    ensure => running,
  }

}
