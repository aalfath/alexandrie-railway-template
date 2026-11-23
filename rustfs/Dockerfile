# RustFS: S3-compatible storage for Alexandrie's uploads and backup archives.
FROM rustfs/rustfs:1.0.6@sha256:ee717072290bec9b11abfc0365f8310b00df1cd9b3639943edae47bdef05044a
# Railway volumes are mounted as root, so run as root to write to /data.
USER root
ENV RUSTFS_ADDRESS=[::]:9000 \
    RUSTFS_VOLUMES=/data \
    RUSTFS_CONSOLE_ENABLE=false \
    RUSTFS_OBS_LOGGER_LEVEL=warn
EXPOSE 9000
ENTRYPOINT ["/etc/rustfs/entrypoint.sh"]
CMD ["rustfs"]
