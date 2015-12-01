#!/usr/bin/env bash

. ${DIR_HOME}/inline/vars.sh
. ${DIR_HOME}/inline/rewrite.sh

FILE_POSTFIX_MAIN_SRC="${DIR_HOME}/inline/postfix/main.cf"
FILE_POSTFIX_MAIN_DEST="/etc/postfix/main.cf"

FILE_POSTFIX_DOMAINS_SRC="${DIR_HOME}/inline/postfix/virtual_domains"
FILE_POSTFIX_DOMAINS_DEST="/etc/postfix/virtual_domains"

FILE_POSTFIX_RCPT_SRC="${DIR_HOME}/inline/postfix/ldap_virtual_recipients.cf"
FILE_POSTFIX_RCPT_DEST="/etc/postfix/ldap_virtual_recipients.cf"

FILE_POSTFIX_ALIASES_SRC="${DIR_HOME}/inline/postfix/ldap_virtual_aliases.cf"
FILE_POSTFIX_ALIASES_DEST="/etc/postfix/ldap_virtual_aliases.cf"

FILE_POSTFIX_IDENT_CHECK_SRC="${DIR_HOME}/inline/postfix/identitycheck"
FILE_POSTFIX_IDENT_CHECK_DEST="/etc/postfix/identitycheck"

FILE_POSTFIX_DROP_SRC="${DIR_HOME}/inline/postfix/drop.cidr"
FILE_POSTFIX_DROP_DEST="/etc/postfix/drop.cidr"

run_task apt-get install --yes makepasswd postfix postfix-pcre postfix-ldap mutt swaks

run_task cp_rewrite ${FILE_POSTFIX_MAIN_SRC} ${FILE_POSTFIX_MAIN_DEST}
run_task cp_rewrite ${FILE_POSTFIX_DOMAINS_SRC} ${FILE_POSTFIX_DOMAINS_DEST}
run_task cp_rewrite ${FILE_POSTFIX_RCPT_SRC} ${FILE_POSTFIX_RCPT_DEST}
run_task cp_rewrite ${FILE_POSTFIX_ALIASES_SRC} ${FILE_POSTFIX_ALIASES_DEST}
run_task cp_rewrite ${FILE_POSTFIX_IDENT_CHECK_SRC} ${FILE_POSTFIX_IDENT_CHECK_DEST}
run_task cp_rewrite ${FILE_POSTFIX_DROP_SRC} ${FILE_POSTFIX_DROP_DEST}

run_task postmap hash:/etc/postfix/virtual_domains
