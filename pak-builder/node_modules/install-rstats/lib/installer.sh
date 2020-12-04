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

function installed_r_versions() {
    ls  /Library/Frameworks/R.framework/Versions |
        tr -d / |
        grep '^[0-9][0-9]*\.[0-9][0-9]*$'
}

# Install all downloaded pkg files
function install_pkg() {
    local pkg=""
    for pkg in "$@"
    do
        echo "Installing ${pkg}"
        forget_r_packages
        installer -pkg "$pkg" -target /
        forget_r_packages
    done
}

function update_access_rights() {
    (
        local id=$(id -u)
        if [[ "$id" != "0" ]]; then
            echo "You need sudo to update access rights"
            exit 1
        fi
        local vers=$(installed_r_versions)
        for ver in $vers
        do
            chmod -R g-w "/Library/Frameworks/R.framework/Versions/$ver"
        done
    )
}

function update_quick_links() {
    local base=/Library/Frameworks/R.framework/Versions/

    # Check that all installed R versions have quick links
    local vers=$(installed_r_versions)
    for ver in $vers
    do
        local linkfile="/usr/local/bin/R-$ver"
        local target="${base}${ver}/Resources/bin/R"
        if [[ ! -e "$linkfile" ]]; then
            echo Creating quick link for R-${ver}...
            ln -s "$target" "$linkfile"
        elif [[ ! -L "$linkfile" ]]; then
            echo File "$linkfile" exists, but it is not a symlink
        else
            local current=$(readlink "$linkfile")
            if [[ "$current" != "$target" ]]; then
                echo Link "$linkfile" exists, but its target is wrong
            fi
        fi
    done

    # Check for dangling links
    local links=$(find /usr/local/bin -regex '^R-[0-9][0-9]*\.[0-9][0-9]*$')
    for link in $links
    do
        if [[ ! -L "$link" ]]; then
            echo Skipping "$link", it is not a symlink
        else
            local current=$(readlink "$link")
            if [[ ! -e "$current" ]]; then
                echo Cleaning up dangling link "$link"
                rm "$link"
            fi
        fi
    done
}

function forget_r_packages() {
    local pkgs=$(pkgutil --pkgs | grep -i r-project | grep -v clang)
    local pkg=""
    for pkg in $pkgs
    do
        pkgutil --forget "$pkg" || true
    done
}

function make_orthogonal() {
    local base=/Library/Frameworks/R.framework/Versions/
    local vers=$(installed_r_versions)
    for ver in $vers
    do
        local rfile="${base}${ver}/Resources/bin/R"
        if grep -q 'R.framework/Resources' "$rfile"; then
            echo "Making R $ver orthogonal"
            cat "$rfile" |
                sed 's/R.framework\/Resources/R.framework\/Versions\/'$ver'\/Resources/' \
                    > "${rfile}.new"
            mv "${rfile}.new" "$rfile"
            chmod +x "$rfile"
        fi

        local rfile="${base}${ver}/Resources/etc/Renviron"
        if grep -q 'R.framework/Resources' "$rfile"; then
            cat "$rfile" |
                sed 's/R.framework\/Resources/R.framework\/Versions\/'$ver'\/Resources/' \
                    > "${rfile}.new"
            mv "${rfile}.new" "$rfile"
        fi

        local rfile="${base}${ver}/Resources/fontconfig/fonts/fonts.conf"
        if grep -q 'R.framework/Resources' "$rfile"; then
            cat "$rfile" |
                sed 's/R.framework\/Resources/R.framework\/Versions\/'$ver'\/Resources/' \
                    > "${rfile}.new"
            mv "${rfile}.new" "$rfile"
        fi

        local rfile="${base}${ver}/Resources/etc/Makeconf"
        if grep -q 'F/Library/Frameworks/R\.framework/\.\.' "$rfile"; then
            cat "$rfile" |
                sed 's/-F\/Library\/Frameworks\/R\.framework\/\.\./-F\/Library\/Frameworks\/R.framework\/Versions\/'$ver'/' \
                    > "${rfile}.new"
            mv "${rfile}.new" "$rfile"
        fi

        local fake="${base}${ver}/R.framework"
        mkdir -p "$fake"
        ln -s ../Headers "$fake/Headers" 2> /dev/null || true
        ln -s ../Resources/lib "$fake/Libraries" 2> /dev/null || true
        ln -s ../PrivateHeaders "$fake/PrivateHeaders" 2> /dev/null || true
        ln -s ../R "$fake/R" 2> /dev/null || true
        ln -s ../Resources "$fake/Resources" 2> /dev/null || true
    done
}

function main() {
    set -e
    install_pkg "$@"
    make_orthogonal
    update_access_rights
    update_quick_links
}

if [ "$sourced" = "0" ]; then
    set -e
    main "$@"
fi
