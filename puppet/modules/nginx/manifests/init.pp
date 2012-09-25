class nginx {
	
	package{'nginx':
		ensure => present,
	}
	
	file{'nginx_conf':
		ensure => file,
		owner => "root",
		path => "/etc/nginx/nginx.conf",
		source => "puppet:///nginx/nginx.conf",
		require => Package["nginx"],
		notify => Service["nginx"]
	}
	
	file{'cambioclave_conf':
		ensure => file,
		owner => "root",
		path => "/etc/nginx/conf.d/cambio_clave.conf",
		source => "puppet:///nginx/cambio_clave.conf",
		require => File["nginx_conf"],
		notify => Service["nginx"]
	}
	
	service{'nginx':
		ensure => running,
		enable => true,
		hasstatus => true,
		hasrestart => true,
		require => File["cambioclave_conf"]
	}
	
	file {"cambioclave_init":
		ensure => file,
		owner => "root",
		path => "/etc/init.d/cambioclave",
		mode => "0755",
		source => "puppet:///nginx/cambio_clave_init.sh",
		notify => Service["cambioclave"]
	}
	
	service {"cambioclave":
		ensure => running,
		enable => true,
		hasstatus => true,
		hasrestart => true,
		require => [File["cambioclave_init"], Exec["chkconfig --add cambioclave"]]
	}
	
	exec {"chkconfig --add cambioclave": 
		path => "/sbin",
		require => File["cambioclave_init"]
	}
	
}
