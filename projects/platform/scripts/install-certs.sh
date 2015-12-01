#!/usr/bin/env bash

. ${DIR_HOME}/inline/vars.sh

DIR_CERTS_SRC="${DIR_HOME}/inline/certs"
DIR_CERTS_DEST="/etc/certs"

echo ":: Installing certs"

if [ -e ${DIR_CERTS_DEST} ]; then
  rm -rf ${DIR_CERTS_DEST}
fi

mkdir -p ${DIR_CERTS_DEST}

cp -R ${DIR_CERTS_SRC}/* ${DIR_CERTS_DEST}
