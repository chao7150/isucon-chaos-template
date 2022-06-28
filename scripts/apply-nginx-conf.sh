#!/bin/sh

if [ -d nginx ]; then
  diff -ru /etc/nginx nginx
  rsync -rl --delete nginx/ /etc/nginx
else
  echo "リポジトリ内にnginxの設定ファイルがありません"
fi