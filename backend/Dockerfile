# Alexandrie API (Go), official image.
# The official image is distroless (no shell), so a static BusyBox is copied in for
# start.sh, which waits for MySQL and RustFS before starting the API.
FROM busybox:1.37.0-musl@sha256:f6a95d611e0a8780fabdb2aec43e31275b2720dfefa3e41b16835bfc42454478 AS busybox

FROM ghcr.io/smaug6739/alexandrie-backend:v8.14.4@sha256:4a9cee27c9b6b75367d1450feedf4f0ed3f74d0835b80a775c7b930944b2e4fe
COPY --from=busybox /bin/busybox /busybox/busybox
COPY start.sh /busybox/start.sh
ENV BACKEND_PORT=8201 \
    GIN_MODE=release \
    ALLOW_UNSECURE=false \
    MINIO_BUCKET=alexandrie \
    MINIO_SECURE=false
EXPOSE 8201
ENTRYPOINT ["/busybox/busybox", "sh", "/busybox/start.sh"]
