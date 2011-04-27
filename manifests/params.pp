# Class: exim::params
#
#
class exim::params {
	$basename = $operatingsystem ? {
		/(?i)(Debian|Ubuntu)/ => 'exim4',
		/(?i)(RedHat|CentOS)/ => 'exim'
	}
	
	$configdir = "/etc/${basename}"
	
	$greylist = $exim_greylist ? {
		'true'  => true,
		'false' => false,
		default => false
	}
	
	$mysql = $exim_mysql ? {
		'true'  => true,
		'false' => false,
		default => false
	}
	
	$pgsql = $exim_pgsql ? {
		'true'  => true,
		'false' => false,
		default => false
	}
	
	# This option only applies to Debian/Ubuntu
	$daemon_weight = $exim_daemon_weight ? {
		'light' => 'light',
		'heavy' => 'heavy',
		default => ($greylist or $mysql or $pgsql) ? {
			true  => 'heavy',
			false => 'light'
		}
	}
	
	$ports = $exim_ports ? {
		''      => [ '25', '465', '587' ],
		default => split($exim_ports, ',')
	}
	
	$localonly = $exim_localonly ? {
		'true'  => true,
		'false' => false,
		default => false
	}
	
	$munin_checks = $exim_munin_checks ? {
		'true'  => true,
		'false' => false,
		default => true
	}

	$logfile = $operatingsystem ? {
		/(?i)(Debian|Ubuntu)/ => 'mainlog',
		/(?i)(RedHat|CentOS)/ => 'main.log'
  }

  $stats_group = $operatingsystem ? {
		/(?i)(Debian|Ubuntu)/ => 'adm',
		/(?i)(RedHat|CentOS)/ => 'exim'
  }

	$nagios_checks = {
    '25'        => 'tls',
    '465'       => 'ssl',
    '587'       => 'tls',
    'cert_days' => '10',
    'dnsbl'     => true,
    'hostname'  => $fqdn
  }

	$manage_shorewall = $exim_manage_shorewall ? {
		'true'  => true,
		'false' => false,
		default => true
	}
}
