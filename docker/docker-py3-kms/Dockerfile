# Switch to the target image
FROM alpine:edge

ARG BUILD_COMMIT=unknown \
    BUILD_BRANCH=unknown

ARG CONT_UID=1001
ARG CONT_USER=kms

ENV IP=127.0.0.1 \
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
COPY docker/docker-py3-kms/requirements.txt /app
COPY py-kms /app

WORKDIR /app

RUN apk update \
    && apk upgrade \
    && apk add \
        tzdata \
        python3 \
        py3-pip \
        sqlite-libs \
        ca-certificates \
    # TODO: Use venv instead of... this. 
    && pip3 install --no-cache-dir -r /app/requirements.txt --break-system-packages \
    && mkdir -p /app/db /app/scripts

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

COPY docker/start.py /app/scripts/start.py
COPY docker/healthcheck.py /app/scripts/healthcheck.py

RUN chmod 550 /app/scripts/start.py /app/scripts/healthcheck.py

VOLUME /app/db

RUN chown -Rf ${CONT_USER}:${CONT_USER} /app

USER ${CONT_USER}
ENTRYPOINT /usr/bin/python3 -u /app/scripts/start.py
