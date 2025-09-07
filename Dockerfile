FROM clamav/clamav:1.3

COPY clamd.conf /etc/clamav/clamd.conf

# Prime signatures (without volumes it re-downloads each boot  acceptable)
RUN freshclam || true

EXPOSE 3310
CMD bash -lc 'freshclam || true; exec clamd -c /etc/clamav/clamd.conf --foreground=true'

