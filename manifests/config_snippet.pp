define exim::config_snippet ($content = false) {
	if ($content) {
		$real_content = $content
		$source = undef
	} else {
		$source = [ "puppet:///modules/site-exim/conf.d/${fqdn}/${name}",
                "puppet:///modules/site-exim/conf.d/${exim_component_type}/${name}",
                "puppet:///modules/site-exim/conf.d/${exim_component_cluster}/${name}",
                "puppet:///modules/site-exim/conf.d/${name}" ]
		$real_content = undef
	}
  
	file { "${exim::params::configdir}/conf.d/${name}":
		content => $real_content,
		source  => $source,
		owner   => 'root',
		group   => 'root',
		mode    => '0640',
		notify  => Class['exim::service'],
		require => Class['exim::config']
  }
}
