## 公開鍵
```
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFM+HNOcnqufqnS/Fep8NstcM2dJmpYDMjp+UBqANO12 chao@chao-home
```

## 最初に注意したい

### topでunattended-upgradeがCPUを100%使っている
- 古いAMI等でaptパッケージのバージョンが遅れていると自動更新に時間がかかる
```
sudo vim /etc/apt/apt.conf.d/20auto-upgrades
APT::Periodic::Unattended-Upgrade "0";  // 1だったのを0にする
sudo reboot
```

## ミドルウェア

### git

```
vim ~/.gitconfig

[user]
        email = chaos@examle.com
        name = chaos
```

### nginx

#### nginxのログ出力をjsonにする

```
# /etc/nginx/nginx.conf
	log_format json escape=json '{"time":"$time_iso8601",'
                                    '"host":"$remote_addr",'
                                    '"port":$remote_port,'
                                    '"method":"$request_method",'
                                    '"uri":"$request_uri",'
                                    '"status":"$status",'
                                    '"body_bytes":$body_bytes_sent,'
                                    '"referer":"$http_referer",'
                                    '"ua":"$http_user_agent",'
                                    '"request_time":"$request_time",'
                                    '"response_time":"$upstream_response_time"}';
	access_log /var/log/nginx/access.log json;
```

#### nginx.confの変更を反映する

```
sudo nginx -t
sudo systemctl restart nginx
```
### DB

### スロークエリログ

```
[mysqld]
slow_query_log      = 1
slow_query_log_file = /var/log/mysql/mysql-slow.log
long_query_time     = 0
```

#### インデックス

- EXPLAINでfilesortになっている
  - MySQL5系ではORDER BYにASCとDESCが混在するとインデックスが効かずfilesortになり遅い
    - generated column（>=5.7.6）で正負逆転したカラムを作りASCだけかDESCだけにする
    - https://yk5656.hatenadiary.org/entry/20140206/1392097362

## ツール

### alp

#### インストール

```
wget https://github.com/tkuchiki/alp/releases/download/v1.0.9/alp_linux_amd64.tar.gz -P /tmp
sudo tar -zxvf /tmp/alp_linux_amd64.tar.gz -C /bin
```

#### nginxのログを集計する

```
sudo alp json --file /var/log/nginx/access.log
```

### pt-query-digest

#### インストール

```
sudo apt install percona-toolkit
```

### pprof

#### セットアップ
```go
アプリケーションに以下を追加
import _ "net/http/pprof"

go func() {
	log.Println(http.ListenAndServe("localhost:6060", nil))
}()
```
```
sudo apt install graphviz
```

#### 計測
```
go tool pprof -http=0.0.0.0:1080 http://localhost:6060/debug/pprof/profile
```

### ab

#### インストール

```
apt install apache2-utils
```

#### 使う

```
ab -c 1 -n 10 http://localhost/
```

### top

- -1でコア別表示
- us user
- sy system
  - forkやコンテキストスイッチ
- 優先度が変更されたプロセスによる利用
- id 利用されてない
- wa IO待ち
- hi ハードウェア割り込み
- si ソフト割り込み
- st ハイパーバイザによる利用

## 操作

### 特定サービスのログを見る
```
journalctl -u isuumo.go.service
```

### sudoでパイプする
```
sudo sh -c "cat nginx/sites-enabled/isuumo.conf > /etc/nginx/sies-enabled/isuumo.conf"
```

## Linuxのパラメータ

### ulimit

- 各プロセスのリソース制限
- ulimit -a
- cat /proc/674/limits
- 見るべきはMax open files
- 編集は/etc/systemd/system/hoge.serviceで上書き可能

