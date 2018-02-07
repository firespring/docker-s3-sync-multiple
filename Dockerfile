FROM alpine:latest
MAINTAINER Firespring "info.dev@firespring.com"

ENV GLIBC 2.23-r3
RUN apk add --update --no-cache gettext curl python unzip docker openssl ca-certificates \
    && wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://raw.githubusercontent.com/sgerrand/alpine-pkg-glibc/master/sgerrand.rsa.pub \
    && wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/$GLIBC/glibc-$GLIBC.apk \
    && apk add --no-cache glibc-$GLIBC.apk && rm glibc-$GLIBC.apk \
    && ln -s /lib/libz.so.1 /usr/glibc-compat/lib/ \
    && ln -s /lib/libc.musl-x86_64.so.1 /usr/glibc-compat/lib \
    && rm -rf /var/cache/apk/*

# Install docker-compose
RUN curl -L https://github.com/docker/compose/releases/download/1.18.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose \
    && chmod +x /usr/local/bin/docker-compose

# install latest awscli and clean up
RUN curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip" \
    && unzip awscli-bundle.zip \
    && ./awscli-bundle/install -i /usr/local/ \
    && rm -rf awscli-bundle/* awscli-bundle.zip

ENV AWS_DEFAULT_REGION us-west-2
ENV AWS_ACCESS_KEY_ID ''
ENV AWS_SECRET_ACCESS_KEY ''
ENV AWS_SESSION_TOKEN ''
ENV AWS_OPTIONS ''
ENV AWS_SYNC_OPTIONS ''
ENV SOURCE_LOCATION '/directory'
ENV DEST_LOCATION '/bucket'
ENV SYNC_PERIOD 0

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
VOLUME /var/run/docker.sock
CMD ["docker-compose up"]
