# Create symbolic link in the user systemd directory pointing to the service file in this directory 
rm ~/.config/systemd/user/code-serve-web.service
ln -s $(pwd)/code-serve-web.service ~/.config/systemd/user/code-serve-web.service

# Reload systemd daemon
systemctl --user daemon-reload

# Enable the service to start on boot
systemctl --user enable code-serve-web.service

# Start the service
systemctl --user restart code-serve-web.service

# Create self-signed certificate
external_ip=$(curl -s https://ipv4.icanhazip.com)
openssl req -x509 -nodes -days 1 -newkey rsa:2048 -keyout selfsigned.key -out selfsigned.crt -subj "/CN=${external_ip}"

# make Caddyfile, reverse-proxy from 8000 to 12345
echo "${external_ip}:12345 {
	tls /config/selfsigned.crt /config/selfsigned.key
	reverse_proxy localhost:8000
}" > Caddyfile

# Start caddy
docker run --rm \
    --name caddy \
    -p 12345 \
    -v $(pwd)/Caddyfile:/etc/caddy/Caddyfile \
    -v $(pwd)/selfsigned.crt:/config/selfsigned.crt \
    -v $(pwd)/selfsigned.key:/config/selfsigned.key \
    caddy:2.7.6-alpine
