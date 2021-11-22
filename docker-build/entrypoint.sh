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

function main() {
    set -e

    echo "" # see https://github.com/actions/toolkit/issues/168

    sanitize "${INPUT_R_VERSION}"       "r_version"
    sanitize "${INPUT_DOCKER_NAME}"     "docker_name"
    sanitize "${INPUT_GITHUB_NAME}"     "github_name"
    sanitize "${INPUT_DOCKER_USERNAME}" "docker_username"
    sanitize "${INPUT_DOCKER_PASSWORD}" "docker_password"
    sanitize "${INPUT_GITHUB_USERNAME}" "github_username"
    sanitize "${INPUT_GITHUB_TOKEN}"    "github_token"

    docker_login docker.io \
                 "${INPUT_DOCKER_USERNAME}" "${INPUT_DOCKER_PASSWORD}"
    docker_login docker.pkg.github.com \
                 "${INPUT_GITHUB_USERNAME}" "${INPUT_GITHUB_TOKEN}"
    default_image="docker.io/${INPUT_DOCKER_NAME}:${INPUT_R_VERSION}"

    tags=$(calculate_tags "${INPUT_DOCKER_NAME}" "${INPUT_R_VERSION}")

    docker buildx create --use
    docker buildx ls
    docker buildx inspect

    # We need this for splitting the extra tags
    IFS=" "

    # We cannot store multi-platform images locally, we need to push them
    # to the registry right away. We could specify all tags in a single
    # `docker buildx build`, but this is fine as well, docker will not
    # rebiuld the image multiple times, of course.

    alltags="${INPUT_R_VERSION} ${tags} ${INPUT_EXTRA_TAGS}"
    alltags=$(echo $alltags | tr -s " ")
    for tag in ${alltags}; do
        docker buildx build --push \
               --platform linux/amd64,linux/arm64 \
               --build-arg R_VERSION="${INPUT_R_VERSION}" \
               -t "docker.io/${INPUT_DOCKER_NAME}:${tag}" .
        docker buildx build --push \
               --platform linux/amd64,linux/arm64 \
               --build-arg R_VERSION="${INPUT_R_VERSION}" \
               -t "docker.pkg.github.com/${INPUT_GITHUB_NAME}:${tag}" .
    done

    echo "::set-output name=tags::${alltags}"
    digest=$(docker inspect --format='{{index .RepoDigests 0}}' ${default_image})
    echo "::set-output name=digest::${digest}"

    docker logout docker.io
    docker logout docker.pkg.github.com
}

function sanitize() {
    if [ -z "${1}" ]; then
        >&2 echo "Unable to find '${2}'. Did you set 'with.${2}'?"
        exit 1
    fi
}

function docker_login() {
    echo "${3}" | docker login -u "${2}" --password-stdin "${1}"
}

function calculate_tags() {
    local image="${1}"
    local r_version="${2}"
    if [ "${r_version}" = "devel" ]; then
        local tags=""
    elif [ "${r_version}" = "patched" ]; then
        local r_version_number=$(get_r_version_number "${1}:${r_version}")
        local r_major=$(echo ${r_version_number} | sed 's/[.][0-9][0-9]*$//')
        local tags="${r_version_number}-patched ${r_major}-patched"
    else
        local r_major=$(echo ${r_version} | sed 's/[.][0-9][0-9]*$//')
        local tags="${r_major}"
    fi
    echo "${tags}"
}

function get_r_version_number() {
    local image="${1}"
    docker run --rm "${image}" R --slave -e 'cat(format(getRversion()))'
}

if [ "$sourced" = "0" ]; then
    set -x
    main
fi
