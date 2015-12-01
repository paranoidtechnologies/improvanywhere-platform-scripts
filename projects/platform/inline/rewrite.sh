#!/usr/bin/env bash

REPLACE=("DC_DOMAIN" "DOMAIN_NAME" "DOMAIN_IDN" "DOMAIN_BASE" "DOMAIN_MAIL" "LDAP_POSTFIX_PASSWORD" "LDAP_DOVECOT_PASSWORD")

function replace_vars {
  infile=$1
  IFS=" "

  while read line; do
    for var in ${REPLACE[@]}; do
      line=$(echo "${line}" | sed -e "s/\${${var}}/${!var}/g")
    done

    echo "${line}"
  done < "${infile}"

  unset IFS
}


function cp_rewrite {
  infile=$1
  outfile=$2

  echo ":: Configure $2"
  replace_vars $1 > $2
}

export -f replace_vars
export -f cp_rewrite
