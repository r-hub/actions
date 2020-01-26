FROM docker:19.03.5 as runtime
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
