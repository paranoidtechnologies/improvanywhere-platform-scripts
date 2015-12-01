#!/usr/bin/env bash

function generatePassword {
  makepasswd --chars=33
}

export LDAP_POSTFIX_PASSWORD=$(generatePassword)
export LDAP_DOVECOT_PASSWORD=$(generatePassword)
