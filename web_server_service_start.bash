#!/usr/bin/env bash


projectdir=$(dirname $0)
service_file="spending.service"

if [[ -e "$projectdir/$service_file" ]]; then
    echo 'start service'
    systemctl start spending
    systemctl status spending
    exit
fi

nodejs_path_binary=$(dirname $(whereis -b node | cut -d: -f2))

echo 'Generate service file'
cat << EOF > "$projectdir/$service_file" 
[Unit]
Description=Spending money app

[Service]
ExecStart=$projectdir/web_server.service.bash
Restart=on-failure
User=$USER
Group=nogroup
Environment=PATH=/usr/bin:/usr/local/bin:$nodejs_path_binary
Environment=NODE_ENV=production
Environment=DISPLAY=:0
Environment=XDG_RUNTIME_DIR=/run/user/$(id -u)
WorkingDirectory=$projectdir

[Install]
WantedBy=multi-user.target
EOF

echo 'Copy service file'
sudo cp -f "$projectdir/$service_file" /etc/systemd/system

echo 'Start service'
systemctl start spending
systemctl status spending
