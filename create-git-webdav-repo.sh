#!/bin/bash

if [ $# -eq 1 ]; then
	DAV_DIR="/var/www/dav"
	REPO_NAME="${1}.git"
	REPO_DIR="${DAV_DIR}/${REPO_NAME}"
	if [ -d $DAV_DIR ]; then
		sudo -u www-data mkdir -p ${REPO_DIR}
		cd ${REPO_DIR}
		sudo -u www-data git init --bare
		sudo -u www-data git update-server-info
	fi
fi

