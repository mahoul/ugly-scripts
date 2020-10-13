#!/bin/bash

# vim: set expandtab!:

running_in_lxc(){
	grep -qa container=lxc /proc/1/environ
}

is_debian(){
	/usr/bin/lsb_release -s -i | grep -q -i debian && return 0 || return 1 
}

is_ubuntu(){
	/usr/bin/lsb_release -s -i | grep -q -i ubuntu && return 0 || return 1 
}

is_rhel_var(){
	[ -s /etc/redhat-release ] && return 0 || return 1
}

is_deb_variant(){
	[ -x /usr/bin/lsb_release ] && return 0 || return 1
}

if is_debian || is_ubuntu; then
        # Install Apache webserver
	apt update
	apt install -y apache2

        # Tweak the config if running inside an LXC container
        #
	if running_in_lxc; then
		[ ! -d /etc/systemd/system/apache2.service.d ] && mkdir -p /etc/systemd/system/apache2.service.d
		cat  <<-EOF >> /etc/systemd/system/apache2.service.d/override.conf
		# /lib/systemd/system/apache2.service
		[Service]
		PrivateTmp=false
		NoNewPrivileges=yes
		EOF
		systemctl daemon-reload
		systemctl start apache2.service
	fi

        # Create the dav folder and set permissions accordingly
        #
        [ ! -d /var/www/dav ] && mkdir -p /var/www/dav
        chown -R www-data:www-data /var/www/dav

        # Enable Apache DAV modules
        a2enmod dav
        a2enmod dav_fs

        # Add basic WebDav config to default Apache site
        #
	cat <<-'EOF' > /etc/apache2/sites-enabled/000-default.conf
	DavLockDB /var/www/dav/DavLock
	<VirtualHost *:80>
		# The ServerName directive sets the request scheme, hostname and port that
		# the server uses to identify itself. This is used when creating
		# redirection URLs. In the context of virtual hosts, the ServerName
		# specifies what hostname must appear in the request's Host: header to
		# match this virtual host. For the default virtual host (this file) this
		# value is not decisive as it is used as a last resort host regardless.
		# However, you must set it for any further virtual host explicitly.
		#ServerName www.example.com

		ServerAdmin webmaster@localhost
		DocumentRoot /var/www/html

		# Available loglevels: trace8, ..., trace1, debug, info, notice, warn,
		# error, crit, alert, emerg.
		# It is also possible to configure the loglevel for particular
		# modules, e.g.
		#LogLevel info ssl:warn

		ErrorLog ${APACHE_LOG_DIR}/error.log
		CustomLog ${APACHE_LOG_DIR}/access.log combined

		# For most configuration files from conf-available/, which are
		# enabled or disabled at a global level, it is possible to
		# include a line for only one particular virtual host. For example the
		# following line enables the CGI configuration for this host only
		# after it has been globally disabled with "a2disconf".
		#Include conf-available/serve-cgi-bin.conf

		Alias /dav /var/www/dav
		<Directory /var/www/dav>
			DAV On
		</Directory>

	</VirtualHost>
	# vim: syntax=apache ts=4 sw=4 sts=4 sr noet
	EOF

        # Restart Apache2 service
        systemctl restart apache2
fi

