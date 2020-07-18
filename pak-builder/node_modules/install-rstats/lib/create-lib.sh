#! /bin/bash

sourced=0
if [ -n "$ZSH_EVAL_CONTEXT" ]; then
    case $ZSH_EVAL_CONTEXT in *:file) sourced=1;; esac
elif [ -n "$KSH_VERSION" ]; then
    [ "$(cd $(dirname -- $0) && pwd -P)/$(basename -- $0)" != "$(cd $(dirname -- ${.sh.file}) && pwd -P)/$(basename -- ${.sh.file})" ] && sourced=1
elif [ -n "$BASH_VERSION" ]; then
    (return 0 2>/dev/null) && sourced=1
else
    # All other shells: examine $0 for known shell binary filenames
    # Detects `sh` and `dash`; add additional shell filenames as needed.
    case ${0##*/} in sh|dash) sourced=1;; esac
fi

function create_libs() {
    local vers=$(installed_r_versions)
    local base="/Library/Frameworks/R.framework/Versions"
    for ver in $vers
    do
        renv="$base/$ver/Resources/etc/Renviron"
        lib=$(bash -c "source $renv; echo \$R_LIBS_USER")
        # This is to expand the tilde
        lib=$(bash -c "echo $lib")
        if test -e "$lib"; then
            if ! test -d "$lib"; then
                echo "Warning: library '$lib' is not a directory"
            fi
        else
            echo "Creating library '$lib'"
            mkdir -p $lib || echo "Failed to create '$lib'"
        fi
    done
}

function main() {
    set -e
    local scriptdir=$(dirname $0)
    source "$scriptdir/installer.sh"
    create_libs
}

if [ "$sourced" = "0" ]; then
    set -e
    main "$@"
fi
