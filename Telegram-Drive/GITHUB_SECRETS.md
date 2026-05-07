**GitHub Secrets — Telegram-Drive**

Add the following repository secrets (Settings → Secrets → Actions) for secure CI and deployment.

- **STREAM_TOKEN**: token used by the streaming endpoint.
- **DOMAIN**: your domain (e.g., example.com) used for certbot/nginx config.
- **LETSENCRYPT_EMAIL**: email for Let's Encrypt registration.
- **AWS_ACCESS_KEY_ID**: if using S3 backups.
- **AWS_SECRET_ACCESS_KEY**: if using S3 backups.
- **BACKUP_S3_BUCKET**: optional S3 bucket name for backups.
- **GITHUB_PUSH_TOKEN**: optional personal access token for automated pushes (if used by scripts).

Recommended scopes (if creating a PAT for `GITHUB_PUSH_TOKEN`): `repo` (public_repo/private_repo as needed) and `workflow`.

After adding secrets, update CI/workflows to reference them via `${{ secrets.NAME }}`.
