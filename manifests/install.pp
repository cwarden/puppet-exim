# Class: exim::install
#
#
class exim::install {
	package { $exim::params::basename:
		ensure => installed
  }

	if $operatingsystem =~ /(?i)(Debian|Ubuntu)/ {
		# exim4-daemon-* packages are mutually exclusive so installing one
		# will remove the other
		package { "exim4-daemon-${exim::params::daemon_weight}":
			ensure => installed
		}
	}
}
