#!/bin/sh
set -e

# Substitute environment variables into nginx config template
envsubst '$$DOMAIN $$STREAM_PORT $$STREAM_TOKEN' < /etc/nginx/templates/default.conf.template > /etc/nginx/conf.d/default.conf

exec "$@"
