# modules/exim/manifests/init.pp - manage exim stuff
# Copyright (C) 2007 admin@immerda.ch
#

class exim {
	require exim::params
	
	include exim::install, exim::config, exim::service

	if $exim::params::munin_checks {
		include exim::munin
	}

	if $exim::params::manage_shorewall {
		include shorewall::rules::out::smtp
	}

	if !$exim::params::localonly {
		if $exim::params::manage_shorewall {
			if array_include($exim::params::ports,'25') {
				include shorewall::rules::smtp
			}

			if array_include($exim::params::ports,'587') {
				include shorewall::rules::smtp_submission
			}

			if array_include($exim::params::ports,'465') {
				include shorewall::rules::smtps
			}
		}

		if $exim::params::nagios_checks {
			exim::nagios { $exim::params::ports:
				checks    => $exim::params::nagios_checks,
				cert_days => $exim::params::nagios_checks['cert_days'],
				host      => $exim::params::nagios_checks['hostname']
			}

			nagios::service { "dnsbl_${fqdn}":
				check_command => "check_dnsbl!${exim::params::nagios_checks['hostname']}"
			}

			if $exim::params::nagios_checks['dnsbl'] != true {
				Nagios::Service["dnsbl_${fqdn}"] {
					ensure => absent
				}
			}
		}
	}
}
