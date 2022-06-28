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


### nginxのログ出力をjsonにする

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

### nginx.confの変更を反映する

```
sudo nginx -t
sudo systemctl restart nginx
```

### alp入れる

```
wget https://github.com/tkuchiki/alp/releases/download/v1.0.9/alp_linux_amd64.tar.gz -P /tmp
sudo tar -zxvf /tmp/alp_linux_amd64.tar.gz -C /bin
```

### alpでnginxのログを集計する

```
sudo alp json --file /var/log/nginx/access.log
```

### ab入れる

```
apt install apache2-utils
```

### abする

```
ab -c 1 -n 10 http://localhost/
```

### k6インストール

https://k6.io/docs/getting-started/installation/
```
sudo mkdir /root/.gnupg
sudo chmod 700 /root/.gnupg
sudo gpg --no-default-keyring --keyring /usr/share/keyrings/k6-archive-keyring.gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C5AD17C747E3415A3642D57D77C6C491D6AC1D69
echo "deb [signed-by=/usr/share/keyrings/k6-archive-keyring.gpg] https://dl.k6.io/deb stable main" | sudo tee /etc/apt/sources.list.d/k6.list
sudo apt-get update
sudo apt-get install k6
```

### k6のシナリオをすばやく作成する

## CPU利用率の見方

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

## Linuxのパラメータ

### ulimit

- 各プロセスのリソース制限
- ulimit -a
- cat /proc/674/limits
- 見るべきはMax open files
- 編集は/etc/systemd/system/hoge.serviceで上書き可能