FROM golang:1.25-alpine3.21 as builder
RUN apk add --no-cache bash git make gcc musl-dev
WORKDIR $GOPATH/src/github.com/lightningnetwork/lnd
ADD .src .
ARG TAGS
ARG LDFLAGS
RUN go install -v -tags="$TAGS" -ldflags "$LDFLAGS" ./cmd/lnd ./cmd/lncli
RUN strip /go/bin/lnd /go/bin/lncli

# Final stage
FROM alpine:3.21
RUN apk add --no-cache bash expect
COPY --from=builder /go/bin/lnd /go/bin/lncli /usr/local/bin/
ENTRYPOINT ["lnd", "--datadir=/mnt/data", "--configfile=/mnt/config/lnd.conf"]
