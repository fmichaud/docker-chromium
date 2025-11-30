FROM alpine:3.20

RUN apk add --no-cache \
    chromium \
    ttf-freefont \
    alsa-lib \
    pulseaudio \
    dbus \
    nss \
    ca-certificates \
 && rm -rf /var/cache/apk/*

COPY adds/opt/entrypoint.sh /opt/entrypoint.sh
RUN chmod +x /opt/entrypoint.sh

RUN adduser -D appuser

RUN chown appuser:appuser /opt/entrypoint.sh

USER appuser

WORKDIR /home/appuser

ENV CHROMIUM_USER_DATA_DIR=/home/appuser/.config/chromium


ENTRYPOINT ["/opt/entrypoint.sh"]

CMD []
