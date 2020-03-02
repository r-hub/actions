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

    docker build --build-arg R_VERSION="${INPUT_R_VERSION}" \
           -t "${default_image}" .

    tags=$(calculate_tags "${INPUT_DOCKER_NAME}" "${INPUT_R_VERSION}")

    docker tag "${default_image}" \
           "docker.pkg.github.com/${INPUT_GITHUB_NAME}:$INPUT_R_VERSION"

    # We need this for splitting the extra tags
    IFS=" "

    for tag in $tags $INPUT_EXTRA_TAGS; do
        docker tag "${default_image}" \
               "docker.io/${INPUT_DOCKER_NAME}:${tag}"
        docker tag "${default_image}" \
               "docker.pkg.github.com/${INPUT_GITHUB_NAME}:${tag}"
    done

    alltags="${INPUT_R_VERSION} ${tags} ${INPUT_EXTRA_TAGS}"
    alltags=$(echo $alltags | tr -s " ")
    for tag in ${alltags}; do
        docker push "docker.io/${INPUT_DOCKER_NAME}:${tag}"
        docker push "docker.pkg.github.com/${INPUT_GITHUB_NAME}:${tag}"
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
    main
fi
