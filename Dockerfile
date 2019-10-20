FROM golang as builder
LABEL maintainer "Nicolas Zin <nicolas.zin@gmail.com>"

WORKDIR /go/src/github.com/nzin/prometheus-cachethq
COPY . .
RUN set -x && \ 
    go get -d -v . && \
    CGO_ENABLED=0 GOOS=linux go build -a -o prometheus-cachethq .


FROM alpine:3.7
RUN apk add --no-cache ca-certificates
RUN mkdir /app
WORKDIR /app/

COPY --from=builder /go/src/github.com/nzin/prometheus-cachethq/prometheus-cachethq .

RUN addgroup -g 1000 cachet && \
    adduser -S -u 1000 -g cachet cachet

USER cachet

#ENV PROMETHEUS_TOKEN
#ENV CACHETHQ_URL
#ENV CACHETHQ_TOKEN
#ENV SSL_CERT_FILE
#ENV SSL_KEY_FILE

EXPOSE 8080
ENTRYPOINT ["./prometheus-cachethq"]
