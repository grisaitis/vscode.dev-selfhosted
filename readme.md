# requirements

- linux with systemd
- vscode cli (`code`), supporting `code serve-web`
- no firewall for TCP on port 12345

# usage

- if on gcp, allow TCP on 12345

```
gcloud compute firewall-rules create allow-tcp-12345 --direction=INGRESS --priority=1000 --network=default --action=ALLOW --rules=tcp:12345 --source-ranges=0.0.0.0/0
```

- run script

```
setup.sh
```


# notes / to-do's

- start code serve-web
    - add unit file for code serve-web, at port 8000
    - add script for creating symbolic link to unit file
    - add script for enabling the unit file (daemon reload?)
    - add script for starting / restarting the service
- add script for running caddy
    - make TLS cert files, using external IP
    - make Caddyfile, using external IP, port 12345 and reverse-proxy to localhost:8000
    - run Caddy with docker, using Caddyfile and cert files

current state:
- not working, getting ERR_SSL_PROTOCOL_ERROR
