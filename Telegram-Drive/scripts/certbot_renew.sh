#!/bin/sh
set -e

# Run certbot renew once and reload nginx if renewed
docker compose run --rm certbot certonly --webroot -w /var/www/letsencrypt --email "$LETSENCRYPT_EMAIL" --agree-tos --no-eff-email -d "$DOMAIN" || true
docker compose exec nginx nginx -s reload || true
