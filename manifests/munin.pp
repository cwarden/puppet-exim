class exim::munin {
  $group = $::operatingsystem ? {
    'debian' => 'Debian-exim',
    default => 'exim'
  }

	file { '/var/lib/munin/plugin-state/exim_mailstats':
		ensure  => present,
		replace => false,
		owner   => nobody,
		group   => $group,
		mode    => 0640,
		require => Class['exim::install']
  }

  munin::plugin { 'exim_mailstats':
		config => "env.logdir /var/log/${exim::params::basename}\nenv.logname ${exim::params::logfile}\ngroup ${exim::params::stats_group}"
	}

	munin::plugin { 'exim_mailqueue':
		config => "env.exim /usr/sbin/exim\ngroup ${group}"
	}
}
