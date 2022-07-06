#!/bin/sh
set -eu

mv /var/log/nginx/access.log /var/log/nginx/access.log.`date +%Y%m%d-%H%M%S`
nginx -s reopen
mv /var/log/mysql/mysql-slow.log /var/log/mysql/mysql-slow.log.`date +%Y%m%d-%H%M%S`
mysqladmin flush-logs