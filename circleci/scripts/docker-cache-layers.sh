#!/bin/bash
#
# Cache Docker image layers.


PATH_TO_CACHE=


#############
# FUNCTIONS #
#############

# Help.
usage() {
     cat << USAGE_END
     Usage: $0 <options>

Use this script to cache Docker image layers. This is useful when using a CI
environment like CircleCI, where every instance of your build and test node is
a fresh instance.

The images to be cached are currently hard-coded in the source code of this
script. This will change soon.

OPTIONS:
    -d   The path to the Docker image cache directory.
    -h   Show this message.
    -?   Show this message.
USAGE_END
}


################
# PROGRAM FLOW #
################

while getopts "d: h ?" option ; do
    case $option in
        d ) PATH_TO_CACHE="${OPTARG}"
            ;;
        h ) usage
            exit 0;;
        ? ) usage
            exit 0;;
    esac
done


if [[ -z "${PATH_TO_CACHE}" ]] ; then
    echo 'No path to cache directory given.'
    exit 1
else
    # Create cache directory in case it doesn't exist.
    if [[ ! -d "${PATH_TO_CACHE}" ]] ; then
        mkdir -p "${PATH_TO_CACHE}"
    fi
fi

# Currently hard-coded. Change this!
DOCKER_IMAGES='debian:jessie'

for DOCKER_IMAGE in ${DOCKER_IMAGES}; do
    FILENAME="${DOCKER_IMAGE//[^a-zA-Z0-9]/-}"

    # Load cache tarball, if it exists.
    if [[ -e "${PATH_TO_CACHE}/${FILENAME}.tar" ]]; then
        echo "Loading ${DOCKER_IMAGE} from cache..."
        docker load < "${PATH_TO_CACHE}/${FILENAME}.tar" || exit 1
    fi

    echo "Checking ${DOCKER_IMAGE} for update..."
    docker pull "${DOCKER_IMAGE}" | grep "Image is up to date"

    # Store image to cache only, if we pulled an updated version.
    if [[ $? -ne 0 ]] ; then
        echo "Storing ${DOCKER_IMAGE} to cache..."
        docker save "${DOCKER_IMAGE}" > "${PATH_TO_CACHE}/${FILENAME}.tar" || exit 1
    fi
done
