FROM alpine:3.22 AS base

WORKDIR /root
RUN apk add curl git gcc musl-dev
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs -o rust.sh
RUN sh rust.sh -y
ENV PATH="/root/.cargo/bin/:$PATH"

RUN git clone https://github.com/posit-dev/air
WORKDIR /root/air
RUN git fetch --tags
RUN git checkout $(git describe --tags "$(git rev-list --tags --max-count=1)")
RUN cargo build --workspace --exclude zed_air --release
RUN strip -x target/release/air

FROM alpine:3.22 AS final
COPY --from=base /root/air/target/release/air /usr/local/bin/air

LABEL com.github.actions.name="format-r-code" \
    com.github.actions.description="Format R code Using Air from Posit." \
    com.github.actions.icon="check-square" \
    com.github.actions.color="white" \
    maintainer="@gaborcsardi" \
    org.opencontainers.image.url="https://github.com/r-hub/actions" \
    org.opencontainers.image.source="https://github.com/r-hub/actions" \
    org.opencontainers.image.documentation="https://github.com/r-hub/actions/tree/main/format-r-code/" \
    org.opencontainers.image.vendor="Posit, PBC" \
    org.opencontainers.image.description="Format R code Using Air from Posit."

ENTRYPOINT [ "air", "format" ]
