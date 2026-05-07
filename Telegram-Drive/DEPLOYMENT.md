**Deployment checklist**

- Copy `.env.example` to `.env` and fill values (especially `STREAM_TOKEN` and `DOMAIN`).
- Obtain TLS certificates (Certbot/Let's Encrypt) and place them under `./certs` or mount `/etc/letsencrypt`.
- Build and run with Docker Compose:

```bash
cp .env.example .env
# edit .env
docker compose build
docker compose up -d
```

- To run scheduled backups via GitHub Actions, set repository secrets: `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `BACKUP_S3_BUCKET`, and `APP_DATA_DIR` if needed.
- To push these changes from the machine, set `GITHUB_PUSH_TOKEN` and `GITHUB_REPO` in environment then run `./scripts/git_push.sh`.

Certificates with Certbot (automated):

1. Ensure `DOMAIN` and `LETSENCRYPT_EMAIL` are set in `.env`.
2. Start `nginx` so ACME challenges can be served:

```bash
mkdir -p letsencrypt/www
docker compose up -d nginx
```

3. Obtain certificates (one-time):

```bash
./scripts/obtain_certs.sh
```

4. A `certbot` service runs in the compose setup to auto-renew certificates periodically. Manual renewal can be triggered with:

```bash
./scripts/certbot_renew.sh
```


Notes:
- The Actix streaming server reads `STREAM_TOKEN` from env (or generates one if not set). Nginx expects `X-Auth-Token` header to match `STREAM_TOKEN` for `/stream/` proxying.
- TLS certs are not provisioned automatically by this repo — run Certbot externally or adapt the compose file to include a certbot service.
