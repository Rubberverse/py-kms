# Switch to the target image
FROM public.ecr.aws/docker/library/alpine:edge

ARG BUILD_COMMIT=unknown \
    BUILD_BRANCH=next

ARG CONT_UID=1001
ARG CONT_USER=kms

ENV IP=0.0.0.0 \
    DUALSTACK=0 \
    PORT=1688 \
    EPID="" \
    LCID=1033 \
    CLIENT_COUNT=25 \
    ACTIVATION_INTERVAL=120 \
    RENEWAL_INTERVAL=10080 \
    HWID=RANDOM \
    LOGLEVEL=INFO \
    LOGFILE=STDOUT \
    LOGSIZE="" \
    TZ=Europe/Warsaw \
    WEBUI=1

RUN mkdir -p /app
COPY ./requirements.txt /app
COPY --chmod=755 py-kms /app

WORKDIR /app

RUN apk update \
    && apk upgrade \
    && apk add \
        curl \
        tzdata \
        sqlite-libs \
        ca-certificates \
    && apk add --repository=https://mirror.2degrees.nz/alpine/v3.21/main \
        python3 \
        py3-pip \
    && pip3 install --no-cache-dir -r /app/requirements.txt --break-system-packages \
    && mkdir -p /app/db /app/scripts \
    && rm -rf /var/cache/*

RUN addgroup \
    --system \
    --gid ${CONT_UID} \
    ${CONT_USER} \
    && adduser \
        --home "/app" \
        --shell "/bin/sh" \
        --uid ${CONT_UID} \
        --ingroup ${CONT_USER} \
        --disabled-password \
        ${CONT_USER} \
    && rm -rf /var/cache/apt

COPY --chmod=755 ./start.py /app/scripts/start.py
COPY --chmod=755 ./healthcheck.py /app/scripts/healthcheck.py

VOLUME /app/db

RUN chown -Rf ${CONT_USER}:${CONT_USER} /app

USER ${CONT_USER}
ENTRYPOINT /usr/bin/python3 -u /app/scripts/start.py
