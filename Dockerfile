#####
# STEP 1: build base image
#####
FROM docker:20@sha256:0c4066e2407fb67b5cb609aa2ea380cdd774445e6be1cd651096167963125af5 AS base
RUN apk add -U --no-cache bash && \
    apk upgrade && \
    rm -rf /var/cache/apk/*

#####
# STEP 2: install dependencies
#####
FROM base AS dependencies
RUN apk add -U --no-cache wget && \
    rm -rf /var/cache/apk/* && \
    wget -q "https://github.com/aelsabbahy/goss/releases/download/v0.3.16/goss-linux-amd64" -O /usr/bin/goss && \
    chmod +rx /usr/bin/goss && \
    wget -q "https://github.com/aelsabbahy/goss/releases/download/v0.3.16/dgoss" -O /usr/bin/dgoss && \
    chmod +rx /usr/bin/dgoss

#####
# STEP 3: build production image
#####
FROM base AS release
COPY --from=dependencies /usr/bin/goss /usr/bin/goss
COPY --from=dependencies /usr/bin/dgoss /usr/bin/dgoss
CMD ["sh"]
