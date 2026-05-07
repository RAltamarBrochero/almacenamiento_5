**Telegram-Drive — Usage and deployment guide**

Overview
- Telegram-Drive uses your Telegram account as storage. The frontend (app) interacts with the backend (tauri/rust) which uploads/downloads files to Telegram via the grammers client.

Quickstart (local / VPS)
1. Copy example env and edit:
   - `cp Telegram-Drive/.env.example Telegram-Drive/.env`
   - Edit `Telegram-Drive/.env`: set `STREAM_TOKEN`, `DOMAIN`, `LETSENCRYPT_EMAIL` (only if you will use TLS/certbot)
   - IMPORTANT: Do NOT commit `Telegram-Drive/.env` to git. Use GitHub Secrets for CI/hosting.

2. Start with Docker Compose:
```
cd Telegram-Drive
docker compose build
docker compose up -d nginx
./scripts/obtain_certs.sh   # only if DOMAIN and LETSENCRYPT_EMAIL configured
docker compose up -d
```

How to upload files (user flow)
- Open the app (frontend). Connect with your Telegram account using the built-in auth flow (phone/code).
- Use the Upload button or drag-and-drop into the dashboard. The app will split large files into chunks and upload them via the Telegram client.
- Use the sidebar / explorer to navigate uploaded content, preview files, or download.

Security notes
- The streaming endpoint requires a token. The server reads `STREAM_TOKEN` from env; nginx checks `X-Auth-Token` header before proxying `/stream/`.
- Keep `STREAM_TOKEN`, API secrets and session files out of git. Store them in the server environment or GitHub Secrets.

CI / Deployment
- A workflow `docker-publish.yml` builds and pushes an image to GHCR. Configure repository permissions and enable `GITHUB_TOKEN` packages write access.
- Deploy the published image to a server or service (Fly.io / Render / VPS) and pass environment variables there.

Backups
- `./scripts/backup.sh` creates a tar.gz of `APP_DATA_DIR`. Configure S3 credentials in env to upload backups automatically.
- Configure the GitHub workflow `backup.yml` to run on schedule and upload artifacts/s3.

Restoration (basic)
- Download the latest backup artifact or S3 object, extract into your `APP_DATA_DIR` on the server, then restart the container.

Notes and next steps
- Use GitHub Secrets: `STREAM_TOKEN`, `DOMAIN`, `LETSENCRYPT_EMAIL`, `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `BACKUP_S3_BUCKET`.
- If you want, I can add a full `deploy.yml` Action to deploy the built image to Fly.io or Render automatically.
