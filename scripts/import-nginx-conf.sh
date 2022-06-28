#!/bin/sh

if [ -d nginx ]; then
  diff -ru nginx /etc/nginx
fi
rsync -rl --delete /etc/nginx/ nginx