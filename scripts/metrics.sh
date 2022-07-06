#!/bin/sh

# スローログの集計（サンプル）
# pt-query-digest /var/log/mysql/mysql-slow.log > ~/isucon10-chao-training/bench/pt-query-digest.log

# アクセスログの集計（サンプル）
# cat /var/log/nginx/access.log | alp json -m "/api/chair/[0-9]+,/api/recommended_estate/[0-9]+,/api/estate/req_doc/[0-9]+,/api/estate/[0-9]+,/api/chair/buy/[0-9]+" --sort=uri> ~/isucon10-chao-training/bench/alp.log
# cat /var/log/nginx/access.log | alp json -m "/api/chair/[0-9]+,/api/recommended_estate/[0-9]+,/api/estate/req_doc/[0-9]+,/api/estate/[0-9]+,/api/chair/buy/[0-9]+" --sort=uri -q > ~/isucon10-chao-training/bench/alp.query.log