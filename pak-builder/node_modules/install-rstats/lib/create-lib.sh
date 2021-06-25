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

function vercomp () {
    if [[ $1 == $2 ]]
    then
        return 0
    fi
    local IFS=.
    local i ver1=($1) ver2=($2)
    # fill empty fields in ver1 with zeros
    for ((i=${#ver1[@]}; i<${#ver2[@]}; i++))
    do
        ver1[i]=0
    done
    for ((i=0; i<${#ver1[@]}; i++))
    do
        if [[ -z ${ver2[i]} ]]
        then
            # fill empty fields in ver2 with zeros
            ver2[i]=0
        fi
        if ((10#${ver1[i]} > 10#${ver2[i]}))
        then
            return 1
        fi
        if ((10#${ver1[i]} < 10#${ver2[i]}))
        then
            return 2
        fi
    done
    return 0
}

function create_libs() {
    local vers=$(installed_r_versions)
    local base="/Library/Frameworks/R.framework/Versions"
    for ver in $vers
    do
        # from R 4.2.0 R_LIBS_USER is not hard-coded in the config,
        # but we need to run R to query it. This works on older versions
        # as well, but for those we can get away without starting R, so
        # we don't.
        if [[ "`(vercomp $ver 4.1.9; echo $?)`" == "1" ]]; then
            exec="$base/$ver/Resources/R"
            lib=`$exec --vanilla -s -e 'cat(Sys.getenv("R_LIBS_USER"))'`
        else
            renv="$base/$ver/Resources/etc/Renviron"
            lib=$(bash -c "source $renv; echo \$R_LIBS_USER")
        fi
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
