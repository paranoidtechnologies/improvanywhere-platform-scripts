#!/usr/bin/env bash

DIR_CWD=$(dirname "${BASH_SOURCE[0]}")
DIR_HEADER=$(cd "${DIR_CWD}"; cd ..; cd ..; cd extra; pwd)

# Display script header
function show_header_aa {
  cat ${DIR_HEADER}/improvanywhere-logo.aa
  echo
}

export -f show_header_aa
