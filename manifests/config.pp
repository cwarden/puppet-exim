# Class: exim::config
#
#
class exim::config {
	file { "${exim::params::configdir}/exim.conf":
		source  => [ "puppet:///modules/site-exim/${fqdn}/exim.conf",
								 "puppet:///modules/site-exim/${exim_type}/exim.conf",
		             "puppet:///modules/site-exim/exim.conf",
		             "puppet:///modules/exim/exim.conf" ],
		owner   => 'root',
		group   => 'root',
		mode    => '0644',
		notify  => Class['exim::service'],
		require => Class['exim::install']
  }

  file { "${exim::params::configdir}/conf.d":
		source  => "puppet:///modules/common/empty",
		ensure  => directory,
		owner   => 'root',
		group   => 'root',
		mode    => '0755',
		recurse => true,
		purge   => true,
		force   => true,
		notify  => Class['exim::service'],
		require => Class['exim::install']
  }
}
