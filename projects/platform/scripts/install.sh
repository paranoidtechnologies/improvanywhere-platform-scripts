#!/usr/bin/env bash


sudo -sE << EOF
. ${DIR_HOME}/inline/tasks.sh
. ${DIR_HOME}/scripts/service-passwords.sh

#~ run_task ${DIR_HOME}/scripts/preinstall.sh
run_task ${DIR_HOME}/scripts/install-certs.sh
run_task ${DIR_HOME}/scripts/install-ldap.sh
run_task ${DIR_HOME}/scripts/install-postfix.sh
run_task ${DIR_HOME}/scripts/install-dovecot.sh
EOF
