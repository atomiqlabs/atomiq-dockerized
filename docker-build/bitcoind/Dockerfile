FROM alpine:3.21 as builder
RUN apk --no-cache add build-base cmake linux-headers pkgconf python3 libevent-dev boost-dev zeromq-dev sqlite-dev
WORKDIR /src
ADD .src .
RUN cmake -B build -DENABLE_IPC=OFF
RUN cmake --build build
RUN cmake --install build
RUN strip /usr/local/bin/bitcoind /usr/local/bin/bitcoin-cli


FROM alpine:3.21
RUN apk --no-cache add boost-system boost-filesystem boost-chrono boost-thread libevent zeromq bash
COPY --from=builder /usr/local/bin/bitcoind /usr/local/bin/bitcoin-cli /usr/local/bin/
CMD ["bitcoind", "-datadir=/mnt/data", "-conf=/mnt/config/bitcoin.conf"]
