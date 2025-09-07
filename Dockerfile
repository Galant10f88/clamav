FROM clamav/clamav:1.3

COPY clamd.conf /etc/clamav/clamd.conf

# Prime signatures (without volumes it re-downloads each boot  acceptable)
RUN freshclam || true

# Entry point compatible with minimal images (no bash) and Railway's $PORT
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

EXPOSE 3310
ENTRYPOINT ["/docker-entrypoint.sh"]