#####
# STEP 1: build base image
#####
FROM docker:20@sha256:c0ba96f6414f1bf92cc6c5afc25235f507b7fcc1ca0a8ba6884c81aacf434b78 AS base
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
