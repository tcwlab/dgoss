#####
# STEP 1: build base image
#####
FROM docker:20@sha256:b39aa91b8a31462d6e86da84762891f6d2ac5657d34d9bf86fd1d0bd7b60e0d8 AS base
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
