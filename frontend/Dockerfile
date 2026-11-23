# Alexandrie web app (Nuxt), official image.
FROM ghcr.io/smaug6739/alexandrie-frontend:v8.14.4@sha256:b16d27fcbb235164c720125c1ba1a30ca64e025844f866913726bbae1c7f5c79
# Listen on all IPv4 and IPv6 addresses (Railway's private network).
ENV NODE_ENV=production \
    PORT=8200 \
    HOST=:: \
    NITRO_HOST=:: \
    NUXT_PUBLIC_CDN_ENDPOINT=/alexandrie/
EXPOSE 8200
CMD ["/app/docker-entrypoint.sh"]
