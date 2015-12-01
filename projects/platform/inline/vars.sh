#!/usr/bin/env bash

export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export DOMAIN_NAME="improvanywhere"
export DOMAIN_IDN="org"
export DOMAIN_BASE="${DOMAIN_NAME}.${DOMAIN_IDN}"
export DOMAIN_MAIL="mail.${DOMAIN_BASE}"
export DC_DOMAIN="dc=${DOMAIN_NAME},dc=${DOMAIN_IDN}"
