include rvm_setup

user {'itlinux':
	ensure => present,
	home => '/home/itlinux',
	managehome => true,
	shell => '/bin/bash',
}

file {'/home/itlinux/App':
	ensure => directory,
	owner => 'itlinux',
	mode => '0644',
	require => User['itlinux'],
}

package {'sqlite-devel':
	ensure => present,
}

package {'vim-enhanced.x86_64':
	ensure => present,
}

package {'nodejs':
	ensure => present,
}

file {'/root/.curlrc':
	ensure => file,
	owner => "root",
	content => "insecure"
}


class rvm_setup {
	include rvm
	if $rvm_installed == "true" {
		rvm::system_user { itlinux: ; }
	
		rvm_system_ruby {
		  'ruby-1.9.3-p0':
		    ensure => 'present',
			require => File["/root/.curlrc"]
		    default_use => false;
		}
	
		rvm_gemset {
		  "ruby-1.9.3-p0@rails-3.2":
		    ensure => present,
		    require => Rvm_system_ruby['ruby-1.9.3-p0'];
		}
	
		rvm_gem {
		  'ruby-1.9.3-p0@rails-3.2/bundler':
		    require => Rvm_gemset['ruby-1.9.3-p0@rails-3.2'];
		}
		
		rvm_gem {
		  'ruby-1.9.3-p0@rails-3.2/rails':
		    require => [Rvm_gemset['ruby-1.9.3-p0@rails-3.2'], Rvm_gem['ruby-1.9.3-p0@rails-3.2/bundler']];
		}
	}
	
}
