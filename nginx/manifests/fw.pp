class nginx::fw (
  $http_port = "$nginx::http_port",
) {

  firewall { "100 Accept new tcp ${http_port} http connections for puppet_test":
    proto  => 'tcp',
    state  => 'NEW',
    dport  => $http_port,
    action => 'accept',
  }

}
