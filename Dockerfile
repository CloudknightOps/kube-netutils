FROM alpine:latest

RUN apk add --no-cache \
    busybox \
    bind-tools \
    curl \
    inetutils-telnet \
    iproute2 \
    net-tools \
    traceroute \
    iputils \
    && rm -rf /var/cache/apk/*

RUN adduser -D kube-netutils 
USER kube-netutils
WORKDIR /home/kube-netutils
CMD ["sleep", "infinity"]
