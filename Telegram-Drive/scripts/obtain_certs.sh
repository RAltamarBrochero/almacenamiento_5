#!/bin/sh
set -e

if [ -z "$DOMAIN" ]; then
  echo "Please set DOMAIN in environment or .env"
  exit 1
fi
if [ -z "$LETSENCRYPT_EMAIL" ]; then
  echo "Please set LETSENCRYPT_EMAIL in environment or .env"
  exit 1
fi

mkdir -p ./letsencrypt/www
docker compose up -d nginx

echo "Requesting certificate for $DOMAIN using webroot..."
docker compose run --rm certbot certonly --webroot -w /var/www/letsencrypt \
  --email "$LETSENCRYPT_EMAIL" --agree-tos --no-eff-email -d "$DOMAIN"

echo "Certificate requested. Reloading nginx..."
docker compose exec nginx nginx -s reload || true

echo "Done. Certificates are in ./certs/live/$DOMAIN/"
