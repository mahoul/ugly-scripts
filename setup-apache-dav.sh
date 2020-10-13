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
        sed -i \
        -e '1s#^#DavLockDB /var/www/dav\n#' 
        -e 's#</VirtualHost>#\n\tAlias /dav /var/www/dav\n\t<Directory /var/www/dav>\n\t\tDAV On\n\t</Directory>\n</VirtualHost>#' \
        000-default.conf

        # Restart Apache2 service
        systemctl restart apache2
fi

