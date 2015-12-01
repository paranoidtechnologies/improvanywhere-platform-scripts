#!/usr/bin/env bash

. ${DIR_HOME}/inline/vars.sh

locale-gen en_US.UTF-8
dpkg-reconfigure locales

apt-get update
apt-get dist-upgrade --yes
