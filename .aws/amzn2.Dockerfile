
ARG BASE_IMAGE=public.ecr.aws/amazonlinux/amazonlinux:2
ARG VERSION
ARG GIT_COMMIT
ARG DATE
ARG TARGETARCH

FROM $BASE_IMAGE as update
RUN yum upgrade -y;\
    yum install -y shadow-utils;\
    groupadd -r -g 1001 exporter;\
    useradd -g 1001 -M -r -s /bin/bash exporter;\
    yum history undo latest -y;\
    find /var/tmp -name "*.rpm" -print -delete ;\
    find /tmp -name "*.rpm" -print -delete	;\
    yum autoremove -y; \
    yum clean packages; yum clean headers; yum clean metadata; yum clean all; rm -rfv /var/cache/yum

FROM update as intermediate

USER 1001:1001
ENTRYPOINT [ "/usr/bin/nginx-prometheus-exporter" ]


FROM intermediate as container
ADD https://s3.amazonaws.com/rds-downloads/rds-combined-ca-bundle.pem /etc/ssl/certs/
COPY nginx-prometheus-exporter /usr/bin
