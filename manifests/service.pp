# Class: exim::service
#
#
class exim::service {
	service { $exim::params::basename:
		ensure     => running,
		enable     => true,
		hasrestart => true,
		hasstatus  => true,
		require    => Class['exim::config']
  }
}
