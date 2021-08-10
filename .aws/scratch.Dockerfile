
ARG VERSION
ARG GIT_COMMIT
ARG DATE
ARG TARGETARCH
ARG BASE_IMAGE=golang:1.16

FROM $BASE_IMAGE as base
ARG VERSION
ARG GIT_COMMIT
ARG DATE
ARG TARGETARCH

WORKDIR /go/src/github.com/nginxinc/nginx-prometheus-exporter

FROM scratch as intermediate
COPY --from=base /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
USER 1001:1001
ENTRYPOINT [ "/usr/bin/nginx-prometheus-exporter" ]


FROM intermediate as container
COPY nginx-prometheus-exporter /usr/bin/
