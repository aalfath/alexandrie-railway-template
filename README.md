# Alexandrie on Railway

One-click [Alexandrie](https://github.com/Smaug6739/Alexandrie) for Railway: an open-source, offline-first Markdown notes and knowledge-base app (MIT).

- **Alexandrie 8.14.4**, official images `ghcr.io/smaug6739/alexandrie-frontend:v8.14.4` and `ghcr.io/smaug6739/alexandrie-backend:v8.14.4`, pinned by digest.
- **One public domain.** A small Caddy gateway serves the web app, the API (`/api`) and uploaded files (`/alexandrie/…`) from the same origin, so there are no extra domains, CORS or cookie settings to fill in.
- **Persistent data.** Notes and accounts live in Railway's MySQL; uploads and backup archives live in RustFS (S3-compatible) on its own volume.
- **No default passwords.** The JWT secret and the storage keys are generated per deploy. There is no admin account until you create one (see below).

## Services

| Service | Built from | What it does |
|---|---|---|
| `Alexandrie` | `gateway/` (Caddy 2.11.9) | Public domain. Routes `/api` to Backend, `/alexandrie/*` and `/alexandrie-backups/*` to RustFS, everything else to Frontend. Health check `/_health`. |
| `Frontend` | `frontend/` | Nuxt web app on port 8200 (private). Health check `/login`. |
| `Backend` | `backend/` | Go API on port 8201 (private). Runs the database migrations on start; `start.sh` waits for MySQL and RustFS first. |
| `RustFS` | `rustfs/` (RustFS 1.0.6) | S3-compatible storage on port 9000 (private), volume on `/data`. Health check `/health`. |
| `MySQL` | Railway's MySQL | Notes, users, sessions and permissions. |

## Variables

All are set by the template; there is nothing to fill in at deploy time.

| Service | Variable | Default | Purpose |
|---|---|---|---|
| Backend | `JWT_SECRET` | `${{secret(64)}}` | Signs login tokens. Changing it logs everyone out. |
| Backend | `FRONTEND_URL`, `MINIO_PUBLIC_URL` | `https://${{Alexandrie.RAILWAY_PUBLIC_DOMAIN}}` | Public origin (CORS, e-mail links, signed file URLs). |
| Backend | `DATABASE_*` | references to `MySQL` | Database connection. |
| Backend | `MINIO_ENDPOINT`, `MINIO_ACCESSKEY`, `MINIO_SECRETKEY` | references to `RustFS` | Object storage connection. |
| Frontend | `NUXT_PUBLIC_BASE_API`, `NUXT_PUBLIC_BASE_CDN`, `NUXT_PUBLIC_BASE_URL` | `https://${{Alexandrie.RAILWAY_PUBLIC_DOMAIN}}` | Public URLs used by the browser. |
| RustFS | `RUSTFS_ACCESS_KEY`, `RUSTFS_SECRET_KEY` | generated | S3 credentials, used only inside the project. |
| Alexandrie | `BACKEND_UPSTREAM`, `FRONTEND_UPSTREAM`, `RUSTFS_UPSTREAM` | private-network references | Where the gateway sends traffic. |

Optional, add them to **Backend** when you need them (then redeploy Backend):

- `ADMIN_ACCOUNTS`: comma-separated user IDs with admin rights. Sign up, open `https://YOUR-DOMAIN/api/users/@me`, copy `result.id`.
- `CONFIG_DISABLE_SIGNUP=true` (and `NUXT_PUBLIC_CONFIG_DISABLE_SIGNUP_PAGE=true` on Frontend): close registration after you created your account. Signup is open on a fresh deploy.
- `SMTP_HOST`, `SMTP_MAIL`, `SMTP_PASSWORD`, `SMTP_MAIL_FROM`: password-reset e-mails.
- `OIDC_1_CONFIG_URL`, `OIDC_1_CLIENT_ID`, `OIDC_1_CLIENT_SECRET`, `OIDC_1_PROVIDER_NAME`: single sign-on (see the [OIDC guide](https://github.com/Smaug6739/Alexandrie/blob/main/docs/content/6.deploy/5.oidc-and-ldap.md)).

If you add a custom domain to `Alexandrie`, update the `https://…` values on Backend and Frontend to it.

## Notes

- Files in the `alexandrie` bucket are readable by anyone who has their URL (this is how Alexandrie serves images). Backup archives are private and use signed URLs that expire.
- Upload limits are Alexandrie's defaults: 20 MB per file, 1 GB per user.
- Back up both the MySQL volume and the RustFS volume.

## Updates

Every service builds from this repo. When a pinned version is bumped on `main`, Railway shows deployers an "update available" notice, and each deployer chooses when to apply it. Read [CHANGELOG.md](CHANGELOG.md) first: breaking changes are listed first.
