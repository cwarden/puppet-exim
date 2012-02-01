# modules/exim/manifests/init.pp - manage exim stuff
# Copyright (C) 2007 admin@immerda.ch
#

class exim(
  $manage_shorewall = $exim::params::manage_shorewall,
  $localonly = $exim::params::localonly,
  $munin_checks = $exim::params::munin_checks,
  $nagios_checks = $exim::params::nagios_checks,
  $ports = $exim::params::ports
  ) inherits exim::params {
	
	include exim::install, exim::config, exim::service

	if $munin_checks {
		include exim::munin
	}

	if $manage_shorewall {
		include shorewall::rules::out::smtp
	}

	if !$localonly {
		if $manage_shorewall {
			if array_include($ports,'25') {
				include shorewall::rules::smtp
			}

			if array_include($ports,'587') {
				include shorewall::rules::smtp_submission
			}

			if array_include($ports,'465') {
				include shorewall::rules::smtps
			}
		}

		if $nagios_checks {
			exim::nagios { $ports:
				checks    => $nagios_checks,
				cert_days => $nagios_checks['cert_days'],
				host      => $nagios_checks['hostname']
			}

			nagios::service { "dnsbl_${fqdn}":
				check_command => "check_dnsbl!${nagios_checks['hostname']}"
			}

			if $nagios_checks['dnsbl'] != true {
				Nagios::Service["dnsbl_${fqdn}"] {
					ensure => absent
				}
			}
		}
	}
}
