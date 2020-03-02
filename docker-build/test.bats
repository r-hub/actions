#!/usr/bin/env bats

setup() {
    export INPUT_R_VERSION=devel
    export INPUT_DOCKER_NAME=duser/dimage
    export INPUT_GITHUB_NAME=guser/grepo/gimage
    export INPUT_DOCKER_USERNAME=dockeruser
    export INPUT_DOCKER_PASSWORD=dockerpass
    export INPUT_GITHUB_USERNAME=githubuser
    export INPUT_GITHUB_TOKEN=githubtoken
    export INPUT_EXTRA_TAGS=""
}

teardown() {
    true
}

@test "sanitize" {
    source entrypoint.sh
    run sanitize "" foobar
    [ "$status" -eq 1 ]
    [ "$output" = "Unable to find 'foobar'. Did you set 'with.foobar'?" ]

    run sanitize good case
    [ "$status" -eq 0 ]
}

@test "calculate_tags" {
    source entrypoint.sh

    # devel does not get extra tags
    run calculate_tags image devel
    [ "$output" = "" ]

    # version number gets the major version as well
    run calculate_tags image 3.6.2
    [ "$output" = "3.6" ]

    # patched also get <version>-patched and <major>-patched
    function get_r_version_number() { echo "3.6.2"; }
    export -f get_r_version_number

    run calculate_tags image patched
    [ "$output" = "3.6.2-patched 3.6-patched" ]
}

@test "checks for empty arguments" {
    source entrypoint.sh

    # these should not be used, because they come after the argument
    # check
    function docker_login() { false; }
    export -f docker_login

    function docker() { false; }
    export -f docker

    for input in github_token github_username docker_password \
                 docker_username github_name docker_name r_version; do
        unset INPUT_$(echo $input | tr [a-z] [A-Z])
        run main
        [ "$status" = 1 ]
        echo "$output" | grep -q "Unable to find '$input'"
    done
}

@test "all the right tags for devel" {
    source entrypoint.sh

    function docker_login() { true; }
    export -f docker_login

    function docker() {
        if [ "${1}" = "tag" ]; then echo "$@"; fi
    }
    export -f docker

    # just the GH tag for devel
    run main
    output2=$(echo "$output" | grep -v "::set-output")
    exp="
tag docker.io/duser/dimage:devel docker.pkg.github.com/guser/grepo/gimage:devel"
    [ "$output2" = "$exp" ]

    # plus extra tags, if any
    export INPUT_EXTRA_TAGS="extra1 extra2"
    run main
    echo "$output"
    output2=$(echo "$output" | grep -v "::set-output")
    exp="
tag docker.io/duser/dimage:devel docker.pkg.github.com/guser/grepo/gimage:devel
tag docker.io/duser/dimage:devel docker.io/duser/dimage:extra1
tag docker.io/duser/dimage:devel docker.pkg.github.com/guser/grepo/gimage:extra1
tag docker.io/duser/dimage:devel docker.io/duser/dimage:extra2
tag docker.io/duser/dimage:devel docker.pkg.github.com/guser/grepo/gimage:extra2"
    [ "$output2" = "$exp" ]
}

@test "all the right tags for a version" {
    source entrypoint.sh

    function docker_login() { true; }
    export -f docker_login

    function docker() {
        if [ "${1}" = "tag" ]; then echo "$@"; fi
    }
    export -f docker

    # just the GH tag for devel
    export INPUT_R_VERSION="3.6.2"
    run main
    echo "$output"
    output2=$(echo "$output" | grep -v "::set-output")
    exp="
tag docker.io/duser/dimage:3.6.2 docker.pkg.github.com/guser/grepo/gimage:3.6.2
tag docker.io/duser/dimage:3.6.2 docker.io/duser/dimage:3.6
tag docker.io/duser/dimage:3.6.2 docker.pkg.github.com/guser/grepo/gimage:3.6"
    [ "$output2" = "$exp" ]

    # plus extra tags, if any
    export INPUT_EXTRA_TAGS="extra1 extra2"
    run main
    echo "$output"
    output2=$(echo "$output" | grep -v "::set-output")
    exp="
tag docker.io/duser/dimage:3.6.2 docker.pkg.github.com/guser/grepo/gimage:3.6.2
tag docker.io/duser/dimage:3.6.2 docker.io/duser/dimage:3.6
tag docker.io/duser/dimage:3.6.2 docker.pkg.github.com/guser/grepo/gimage:3.6
tag docker.io/duser/dimage:3.6.2 docker.io/duser/dimage:extra1
tag docker.io/duser/dimage:3.6.2 docker.pkg.github.com/guser/grepo/gimage:extra1
tag docker.io/duser/dimage:3.6.2 docker.io/duser/dimage:extra2
tag docker.io/duser/dimage:3.6.2 docker.pkg.github.com/guser/grepo/gimage:extra2"
    [ "$output2" = "$exp" ]
}

@test "all the right tags for patched" {
    source entrypoint.sh

    function docker_login() { true; }
    export -f docker_login

    function docker() {
        if [ "${1}" = "tag" ]; then echo "$@"; fi
    }
    export -f docker

    function calculate_tags() { echo "3.6-patched 3.6.2-patched"; }
    export -f calculate_tags

    # just the GH tag for devel
    export INPUT_R_VERSION="patched"
    run main
    echo "$output"
    output2=$(echo "$output" | grep -v "::set-output")
    exp="
tag docker.io/duser/dimage:patched docker.pkg.github.com/guser/grepo/gimage:patched
tag docker.io/duser/dimage:patched docker.io/duser/dimage:3.6-patched
tag docker.io/duser/dimage:patched docker.pkg.github.com/guser/grepo/gimage:3.6-patched
tag docker.io/duser/dimage:patched docker.io/duser/dimage:3.6.2-patched
tag docker.io/duser/dimage:patched docker.pkg.github.com/guser/grepo/gimage:3.6.2-patched"
    [ "$output2" = "$exp" ]

    # plus extra tags, if any
    export INPUT_EXTRA_TAGS="extra1 extra2"
    run main
    echo "$output"
    output2=$(echo "$output" | grep -v "::set-output")
    exp="
tag docker.io/duser/dimage:patched docker.pkg.github.com/guser/grepo/gimage:patched
tag docker.io/duser/dimage:patched docker.io/duser/dimage:3.6-patched
tag docker.io/duser/dimage:patched docker.pkg.github.com/guser/grepo/gimage:3.6-patched
tag docker.io/duser/dimage:patched docker.io/duser/dimage:3.6.2-patched
tag docker.io/duser/dimage:patched docker.pkg.github.com/guser/grepo/gimage:3.6.2-patched
tag docker.io/duser/dimage:patched docker.io/duser/dimage:extra1
tag docker.io/duser/dimage:patched docker.pkg.github.com/guser/grepo/gimage:extra1
tag docker.io/duser/dimage:patched docker.io/duser/dimage:extra2
tag docker.io/duser/dimage:patched docker.pkg.github.com/guser/grepo/gimage:extra2"
    [ "$output2" = "$exp" ]
}

@test "outputs" {
    source entrypoint.sh

    function docker_login() { true; }
    export -f docker_login

    function docker() {
        if [ "${1}" = "inspect" ]; then echo "BADCAFE"; fi
    }
    export -f docker

    function calculate_tags() { echo ""; }
    export -f calculate_tags

    export INPUT_R_VERSION="patched"
    export INPUT_EXTRA_TAGS="extra1 extra2"
    run main
    echo "$output"
    exp="
::set-output name=tags::patched extra1 extra2
::set-output name=digest::BADCAFE"
    [ "$output" = "$exp" ]
}
