#!/usr/bin/env bash

. ${DIR_HOME}/inline/vars.sh
. ${DIR_HOME}/inline/rewrite.sh

DIR_DOVECOT_CONF_SRC="${DIR_HOME}/inline/dovecot/conf.d"
DIR_DOVECOT_CONF_DEST="/etc/dovecot/conf.d"

FILE_DOVECOT_LDAP_SRC="${DIR_HOME}/inline/dovecot/dovecot-ldap.conf.ext"
FILE_DOVECOT_LDAP_DEST="/etc/dovecot/dovecot-ldap.conf.ext"

echo ":: Installing dovecot"
run_task apt-get install --yes makepasswd dovecot-core dovecot-imapd dovecot-pop3d dovecot-lmtpd dovecot-ldap

for file in ${DIR_DOVECOT_CONF_SRC}/*; do
  name=$(basename ${file})
  run_task cp_rewrite "${file}" "${DIR_DOVECOT_CONF_DEST}/${name}"
done

run_task cp_rewrite ${FILE_DOVECOT_LDAP_SRC} ${FILE_DOVECOT_LDAP_DEST}

addgroup --system --gid 5000 vmail
adduser --system --home /srv/vmail --uid 5000 --gid 5000 --disabled-password --disabled-login vmail

echo "done"
