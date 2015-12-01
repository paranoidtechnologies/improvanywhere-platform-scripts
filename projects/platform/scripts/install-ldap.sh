#!/usr/bin/env bash

. ${DIR_HOME}/inline/vars.sh
. ${DIR_HOME}/inline/rewrite.sh

FILE_LDAPRC_SRC="${DIR_HOME}/inline/ldap/ldaprc"
FILE_LDAPRC_DEST="/root/.ldaprc"

FILE_POSTFIX_BOOK_SRC="${DIR_HOME}/inline/ldap/postfix-book.schema"
FILE_POSTFIX_BOOK_DEST="/etc/ldap/schema/postfix-book.schema"

FILE_LDIF_PERMS_SRC="${DIR_HOME}/inline/ldap/ldif/perms.ldif"
FILE_LDIF_PERMS_DEST="/etc/ldap/perms.ldif"

FILE_LDIF_ROOT_SRC="${DIR_HOME}/inline/ldap/ldif/root.ldif"
FILE_LDIF_ROOT_DEST="/etc/ldap/root.ldif"

FILE_LDIF_OU_PEOPLE_SRC="${DIR_HOME}/inline/ldap/ldif/ou-people.ldif"
FILE_LDIF_OU_PEOPLE_DEST="/etc/ldap/ou-people.ldif"

FILE_LDIF_OU_SERVICES_SRC="${DIR_HOME}/inline/ldap/ldif/ou-services.ldif"
FILE_LDIF_OU_SERVICES_DEST="/etc/ldap/ou-services.ldif"

FILE_LDIF_POSTFIX_BOOK_DEST="/etc/ldap/postfix-book.ldif"
FILE_SCHEMA_CONVERT_SRC="${DIR_HOME}/inline/ldap/schema/convert.conf"
FILE_SCHEMA_CONVERT_DEST="/etc/ldap/schema/convert.conf"

echo "Installing ldap"

apt-get install --yes slapd ldap-utils

run_task cp_rewrite ${FILE_LDAPRC_SRC} ${FILE_LDAPRC_DEST}
run_task cp_rewrite ${FILE_LDIF_ROOT_SRC} ${FILE_LDIF_ROOT_DEST}
run_task cp_rewrite ${FILE_LDIF_PERMS_SRC} ${FILE_LDIF_PERMS_DEST}
run_task cp_rewrite ${FILE_LDIF_OU_PEOPLE_SRC} ${FILE_LDIF_OU_PEOPLE_DEST}
run_task cp_rewrite ${FILE_LDIF_OU_SERVICES_SRC} ${FILE_LDIF_OU_SERVICES_DEST}
run_task cp_rewrite ${FILE_SCHEMA_CONVERT_SRC} ${FILE_SCHEMA_CONVERT_DEST}

ldapadd -Y EXTERNAL -H ldapi:/// -f ${FILE_LDIF_ROOT_DEST}

cp ${FILE_POSTFIX_BOOK_SRC} ${FILE_POSTFIX_BOOK_DEST}

if [ -e /etc/ldap/schema/ldif_output ]; then
  rm -rf /etc/ldap/schema/ldif_output
fi

if [ -e /tmp/ldif ]; then
  rm -rf /tmp/ldif
fi

mkdir /etc/ldap/schema/ldif_output
mkdir /tmp/ldif

cd /etc/ldap/schema

run_task slapcat -f ${FILE_SCHEMA_CONVERT_DEST} -F /tmp/ldif/ -n0

run_task cp /tmp/ldif/cn\=config/cn\=schema/cn\=\{4\}postfix-book.ldif ${FILE_LDIF_POSTFIX_BOOK_DEST}
cutFrom=$(grep -n structural ${FILE_LDIF_POSTFIX_BOOK_DEST} | cut -d: -f1)
cutFrom=$(( cutFrom - 1))

sed -i 's/^dn.*/dn: cn=postfix-book,cn=schema,cn=config/' ${FILE_LDIF_POSTFIX_BOOK_DEST}
sed -i 's/^cn:.*/cn: postfix-book/' ${FILE_LDIF_POSTFIX_BOOK_DEST}
cat ${FILE_LDIF_POSTFIX_BOOK_DEST} | head -${cutFrom} > /tmp/ldif.cut
run_task mv /tmp/ldif.cut ${FILE_LDIF_POSTFIX_BOOK_DEST}

ldapauth="-H ldapi:/// -Y external"


test=$(ldapsearch -LLL $ldapauth -b "cn=schema,cn=config" '(cn=*postfix-book)' | wc -l)

if [ "${test}" == "0" ]; then
  echo ":: Setting up postfix mail box object"
  run_task ldapadd $ldapauth -f ${FILE_LDIF_POSTFIX_BOOK_DEST}
fi

echo ":: Setting up permissions"
ldapadd $ldapauth -f ${FILE_LDIF_PERMS_DEST}

echo ":: Setting up basic structure"
test=$(ldapsearch $ldapauth -LLL -u "(ou=people)" -b "${DC_DOMAIN}" | wc -l)

if [ "${test}" == "0" ]; then
  run_task ldapadd $ldapauth -f ${FILE_LDIF_OU_PEOPLE_DEST}
fi

test=$(ldapsearch $ldapauth -LLL -u "(ou=services)" -b "${DC_DOMAIN}" | wc -l)

if [ "${test}" == "0" ]; then
  run_task ldapadd $ldapauth -f ${FILE_LDIF_OU_SERVICES_DEST}
fi


echo "Done"
