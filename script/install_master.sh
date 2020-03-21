#!/usr/bin/env bash

set -eo pipefail

readonly dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

bold() {
    echo "$(tput bold)$1$(tput sgr0)"
}

for file in $(ls "${dir}" | grep -v "install_master.sh"); do
    echo
    bold "##############################################################################"
    bold "    ${file}"
    bold "##############################################################################"
    echo
    ${dir}/${file}
done

