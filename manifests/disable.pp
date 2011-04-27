class exim::disable {
	Service[$exim::params::basename] {
		enable    => false,
		ensure    => stopped,
		hasstatus => false
	}

	Package[$exim::params::basename] {
		ensure => absent
	}

	File["${exim::params::configdir}/exim.conf"] {
		ensure => absent,
		source => undef
	}

	File["${exim::params::configdir}/conf.d"] {
		ensure => absent,
		source => undef
	}

	if $use_munin {
		File['/var/lib/munin/plugin-state/exim_mailstats'] {
			ensure => absent
		}

		Munin::Plugin['exim_mailstats', 'exim_mailqueue'] {
			ensure => absent
		}
	}
}
