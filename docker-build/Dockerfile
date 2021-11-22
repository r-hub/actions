FROM docker:20.10.11 as runtime
LABEL "repository"="https://github.com/r-hub/actions"
LABEL "maintainer"="admin@r-hub.io"

RUN apk update && apk upgrade && apk add --no-cache git bash

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

FROM runtime as testEnv
RUN apk add --no-cache coreutils bats
ADD test.bats /test.bats
RUN /test.bats

FROM runtime

COPY --from=docker/buildx-bin /buildx /usr/libexec/docker/cli-plugins/docker-buildx
